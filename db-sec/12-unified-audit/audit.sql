-- The runnable score-read audit policy is installed by compose at aceu-trust-service/db/03-audit.sql.
SELECT event_timestamp, dbusername, action_name, object_schema, object_name, sql_text
FROM unified_audit_trail WHERE object_schema='ACEU' AND object_name='SCORES'
ORDER BY event_timestamp DESC FETCH FIRST 25 ROWS ONLY;
