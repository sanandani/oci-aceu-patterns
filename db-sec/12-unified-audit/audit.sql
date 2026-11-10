-- Local verification query for the score-read policy installed by the demo.
WHENEVER SQLERROR EXIT SQL.SQLCODE
-- The full article policy and retention examples are in article-example.md.
ALTER SESSION SET CONTAINER=FREEPDB1;
SET PAGESIZE 50 LINESIZE 220
SELECT event_timestamp, dbusername, action_name, object_schema, object_name, sql_text
FROM unified_audit_trail
WHERE object_schema = 'ACEU' AND object_name = 'SCORES'
ORDER BY event_timestamp DESC FETCH FIRST 25 ROWS ONLY;
