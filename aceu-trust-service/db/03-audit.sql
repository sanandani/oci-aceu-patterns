ALTER SESSION SET CONTAINER=FREEPDB1;
CREATE AUDIT POLICY aceu_score_read_policy ACTIONS SELECT ON aceu.scores;
AUDIT POLICY aceu_score_read_policy;
-- Review the trail after GET /profiles/{id}/score:
SELECT event_timestamp,dbusername,action_name,object_schema,object_name,sql_text
FROM unified_audit_trail WHERE object_schema='ACEU' AND object_name='SCORES' AND action_name='SELECT'
ORDER BY event_timestamp DESC FETCH FIRST 25 ROWS ONLY;
