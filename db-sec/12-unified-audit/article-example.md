# Unified Auditing: practical policies and trail hygiene — worked example

Verbatim worked-example text from the matching enhanced article draft. Commands and code are retained in source order; angle-bracket values are placeholders.

Start by enabling the baseline policies and confirming they are active:

AUDIT POLICY ORA_SECURECONFIG;

AUDIT POLICY ORA_LOGIN_LOGOUT;

SELECT policy_name FROM audit_unified_enabled_policies;

Add custom policies for high-value actions. The EXCEPT clause keeps a batch account from flooding the trail.

CREATE AUDIT POLICY ddl_pol PRIVILEGES CREATE ANY TABLE, DROP ANY TABLE;

AUDIT POLICY ddl_pol EXCEPT app_batch;

CREATE AUDIT POLICY keymgmt_pol ACTIONS ADMINISTER KEY MANAGEMENT;

AUDIT POLICY keymgmt_pol;

CREATE AUDIT POLICY hr_fail_pol ACTIONS SELECT ON hr.employees;

AUDIT POLICY hr_fail_pol WHENEVER NOT SUCCESSFUL;

Keep the trail healthy by archiving and purging through DBMS_AUDIT_MGMT:

BEGIN

DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(

audit_trail_type  => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,

last_archive_time => SYSTIMESTAMP - INTERVAL '90' DAY);

DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(

audit_trail_type        => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,

use_last_arch_timestamp => TRUE);

END;

/

Only run the purge after you have exported what you need to keep. For stronger integrity, mirror selected events to syslog so a privileged database user cannot quietly erase the only copy.
