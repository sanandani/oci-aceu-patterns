ALTER SESSION SET CONTAINER=FREEPDB1;
ALTER SESSION SET CURRENT_SCHEMA=ACEU;
CREATE OR REPLACE PACKAGE aceu_score_engine AUTHID CURRENT_USER AS
  PROCEDURE calculate(p_profile_id NUMBER,p_a OUT NUMBER,p_c OUT NUMBER,p_e OUT NUMBER,p_u OUT NUMBER,p_ua OUT NUMBER,p_uc OUT NUMBER,p_ue OUT NUMBER,p_uu OUT NUMBER,p_explanation OUT VARCHAR2);
END aceu_score_engine;
/
CREATE OR REPLACE PACKAGE BODY aceu_score_engine AS
 PROCEDURE calculate(p_profile_id NUMBER,p_a OUT NUMBER,p_c OUT NUMBER,p_e OUT NUMBER,p_u OUT NUMBER,p_ua OUT NUMBER,p_uc OUT NUMBER,p_ue OUT NUMBER,p_uu OUT NUMBER,p_explanation OUT VARCHAR2) IS
   l_payload CLOB; l_history NUMBER; l_n NUMBER; l_si NUMBER; l_su NUMBER; l_ri NUMBER; l_ru NUMBER; l_sn NUMBER; l_an NUMBER; l_verified NUMBER; l_inferred NUMBER; l_cred NUMBER; l_q NUMBER; l_r NUMBER; l_types NUMBER; l_rare NUMBER; l_comp NUMBER; l_gate NUMBER;
 BEGIN
   SELECT p.payload,CASE WHEN JSON_EXISTS(p.payload,'$.history[0]') THEN 1 ELSE 0 END INTO l_payload,l_history FROM profiles p WHERE p.profile_id=p_profile_id;
   -- A: 0.4 skill-set Jaccard + 0.3 role-set Jaccard + 0.3 authored-skill coverage.
   SELECT COUNT(DISTINCT s.v) INTO l_si FROM JSON_TABLE(l_payload,'$.skills[*]' COLUMNS(v VARCHAR2(100) PATH '$')) s JOIN JSON_TABLE(l_payload,'$.prior_skills[*]' COLUMNS(v VARCHAR2(100) PATH '$')) h ON s.v=h.v;
   SELECT COUNT(*) INTO l_su FROM (SELECT v FROM JSON_TABLE(l_payload,'$.skills[*]' COLUMNS(v VARCHAR2(100) PATH '$')) UNION SELECT v FROM JSON_TABLE(l_payload,'$.prior_skills[*]' COLUMNS(v VARCHAR2(100) PATH '$'))) u;
   SELECT COUNT(DISTINCT s.v) INTO l_ri FROM JSON_TABLE(l_payload,'$.roles[*]' COLUMNS(v VARCHAR2(100) PATH '$')) s JOIN JSON_TABLE(l_payload,'$.prior_roles[*]' COLUMNS(v VARCHAR2(100) PATH '$')) h ON s.v=h.v;
   SELECT COUNT(*) INTO l_ru FROM (SELECT v FROM JSON_TABLE(l_payload,'$.roles[*]' COLUMNS(v VARCHAR2(100) PATH '$')) UNION SELECT v FROM JSON_TABLE(l_payload,'$.prior_roles[*]' COLUMNS(v VARCHAR2(100) PATH '$'))) u;
   SELECT COUNT(DISTINCT v) INTO l_sn FROM JSON_TABLE(l_payload,'$.skills[*]' COLUMNS(v VARCHAR2(100) PATH '$'));
   SELECT COUNT(DISTINCT s.v) INTO l_an FROM JSON_TABLE(l_payload,'$.skills[*]' COLUMNS(v VARCHAR2(100) PATH '$')) s JOIN JSON_TABLE(l_payload,'$.authored_skills[*]' COLUMNS(v VARCHAR2(100) PATH '$')) a ON s.v=a.v;
   p_a:=LEAST(1,GREATEST(0,.4*CASE WHEN l_su=0 THEN 1 ELSE l_si/l_su END+.3*CASE WHEN l_ru=0 THEN 1 ELSE l_ri/l_ru END+.3*CASE WHEN l_sn=0 THEN 1 ELSE l_an/l_sn END));
   p_ua:=CASE WHEN l_history=1 THEN .15 ELSE .35 END;
   SELECT COUNT(CASE WHEN status='verified' THEN 1 END),COUNT(CASE WHEN status='inferred' THEN 1 END),COUNT(*) INTO l_verified,l_inferred,l_n FROM JSON_TABLE(l_payload,'$.credibility_signals[*]' COLUMNS(status VARCHAR2(12) PATH '$.status',strength NUMBER PATH '$.strength'));
   IF l_n=0 THEN p_c:=.5; p_uc:=.5; ELSE
     SELECT LEAST(1,GREATEST(0,((NVL(SUM(CASE WHEN status='verified' THEN strength END),0)+.5*NVL(SUM(CASE WHEN status='inferred' THEN strength END),0))/NULLIF(l_verified+.5*l_inferred,0))*NVL(JSON_VALUE(l_payload,'$.context_relevance' RETURNING NUMBER),1))) INTO p_c FROM JSON_TABLE(l_payload,'$.credibility_signals[*]' COLUMNS(status VARCHAR2(12) PATH '$.status',strength NUMBER PATH '$.strength'));
     p_uc:=LEAST(1,.1+.2*l_inferred/l_n+.15/l_n);
   END IF;
   SELECT COUNT(*),NVL(AVG(quality),0),NVL(AVG(reciprocity),0),COUNT(DISTINCT interaction_type) INTO l_n,l_q,l_r,l_types FROM interactions WHERE profile_id=p_profile_id;
   IF l_n=0 THEN p_e:=.5;p_ue:=.5; ELSE p_e:=LEAST(1,GREATEST(0,.45*l_q+.35*l_r+.20*LEAST(1,l_types/4)));p_ue:=LEAST(.5,.3/l_n); END IF;
   -- Rarity uses distance to nearest consenting peer; complementarity uses distance to a fixed deterministic target vector.
   SELECT NVL(LEAST(1,MIN(VECTOR_DISTANCE(p.skills_vector,q.skills_vector,COSINE))),.5) INTO l_rare FROM profiles p JOIN consent pc ON pc.profile_id=p.profile_id AND pc.consented='Y' JOIN profiles q ON q.profile_id<>p.profile_id JOIN consent qc ON qc.profile_id=q.profile_id AND qc.consented='Y' WHERE p.profile_id=p_profile_id;
   SELECT LEAST(1,GREATEST(0,VECTOR_DISTANCE(skills_vector,TO_VECTOR('[0,1,0,0,1,0,1,0,0,1]'),COSINE))) INTO l_comp FROM profiles WHERE profile_id=p_profile_id;
   l_gate:=LEAST(p_a,p_c,p_e); p_u:=CASE WHEN l_gate<.25 THEN 0 ELSE LEAST(1,GREATEST(0,.5*(l_rare+l_comp)*l_gate)) END; p_uu:=.25;
   p_explanation:='A='||TO_CHAR(p_a,'0.00')||' (±'||TO_CHAR(p_ua,'0.00')||'), C='||TO_CHAR(p_c,'0.00')||' (±'||TO_CHAR(p_uc,'0.00')||'), E='||TO_CHAR(p_e,'0.00')||' (±'||TO_CHAR(p_ue,'0.00')||'), U='||TO_CHAR(p_u,'0.00')||' (±'||TO_CHAR(p_uu,'0.00')||'); U combines VECTOR_DISTANCE rarity and target complementarity, gated by min(A,C,E).';
 END;
END aceu_score_engine;
/
CREATE OR REPLACE PACKAGE aceu_service AUTHID CURRENT_USER AS PROCEDURE score_profile(p_profile_id NUMBER); END;
/
CREATE OR REPLACE PACKAGE aceu_score_entry AUTHID DEFINER ACCESSIBLE BY (PACKAGE aceu_service) AS
 PROCEDURE compute(p_profile_id NUMBER,p_a OUT NUMBER,p_c OUT NUMBER,p_e OUT NUMBER,p_u OUT NUMBER,p_ua OUT NUMBER,p_uc OUT NUMBER,p_ue OUT NUMBER,p_uu OUT NUMBER,p_explanation OUT VARCHAR2);
END aceu_score_entry;
/
CREATE OR REPLACE PACKAGE BODY aceu_score_entry AS
 PROCEDURE compute(p_profile_id NUMBER,p_a OUT NUMBER,p_c OUT NUMBER,p_e OUT NUMBER,p_u OUT NUMBER,p_ua OUT NUMBER,p_uc OUT NUMBER,p_ue OUT NUMBER,p_uu OUT NUMBER,p_explanation OUT VARCHAR2) IS
 BEGIN aceu_score_engine.calculate(p_profile_id,p_a,p_c,p_e,p_u,p_ua,p_uc,p_ue,p_uu,p_explanation); END;
END aceu_score_entry;
/
CREATE OR REPLACE PACKAGE BODY aceu_service AS
 PROCEDURE score_profile(p_profile_id NUMBER) IS a NUMBER;c NUMBER;e NUMBER;u NUMBER;ua NUMBER;uc NUMBER;ue NUMBER;uu NUMBER;x VARCHAR2(2000);ctx VARCHAR2(80);
 BEGIN
   SELECT p.context_name INTO ctx FROM profiles p JOIN consent co ON co.profile_id=p.profile_id AND co.consented='Y' WHERE p.profile_id=p_profile_id;
   aceu_score_entry.compute(p_profile_id,a,c,e,u,ua,uc,ue,uu,x);
   INSERT INTO scores(profile_id,context_name,a_score,c_score,e_score,u_score,a_uncertainty,c_uncertainty,e_uncertainty,u_uncertainty,explanation) VALUES(p_profile_id,ctx,a,c,e,u,ua,uc,ue,uu,x);
 END;
END aceu_service;
/
GRANT SELECT, INSERT ON profiles TO aceu_app;
GRANT SELECT, INSERT ON consent TO aceu_app;
GRANT INSERT ON artifacts TO aceu_app;
GRANT INSERT ON interactions TO aceu_app;
GRANT SELECT, INSERT ON scores TO aceu_app;
GRANT INSERT ON contest_log TO aceu_app;
GRANT EXECUTE ON aceu_service TO aceu_app;
