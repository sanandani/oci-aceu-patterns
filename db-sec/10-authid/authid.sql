-- Synthetic least-privilege demonstration. Execute as schema owner in Oracle Free.
CREATE TABLE authid_demo(id NUMBER PRIMARY KEY, note VARCHAR2(80));
INSERT INTO authid_demo VALUES(1,'synthetic'); COMMIT;
CREATE OR REPLACE PROCEDURE invoker_read AUTHID CURRENT_USER IS n NUMBER; BEGIN SELECT COUNT(*) INTO n FROM authid_demo; DBMS_OUTPUT.PUT_LINE('invoker rows='||n); END;
/
CREATE OR REPLACE PROCEDURE owner_read AUTHID DEFINER IS n NUMBER; BEGIN SELECT COUNT(*) INTO n FROM authid_demo; DBMS_OUTPUT.PUT_LINE('definer rows='||n); END;
/
SET SERVEROUTPUT ON
EXEC invoker_read; EXEC owner_read;
