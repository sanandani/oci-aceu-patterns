# Oracle DB: invoker's vs definer's rights for least-privilege code — worked example

Verbatim worked-example text from the matching enhanced article draft. Commands and code are retained in source order; angle-bracket values are placeholders.

An invoker's rights procedure resolves unqualified names at run time in the caller's schema, so it reads the caller's own orders table.

CREATE OR REPLACE PROCEDURE app_util.list_my_orders

AUTHID CURRENT_USER

AS

BEGIN

FOR r IN (SELECT order_id, status FROM orders) LOOP

DBMS_OUTPUT.PUT_LINE(r.order_id || ' ' || r.status);

END LOOP;

END;

/

A definer's rights entry point is the opposite. It performs one privileged action on the owner's data, and ACCESSIBLE BY restricts which program units may call it.

CREATE OR REPLACE PROCEDURE app_admin.close_period (p_period IN NUMBER)

AUTHID DEFINER

ACCESSIBLE BY (PACKAGE app_api.billing)

AS

BEGIN

UPDATE fiscal_periods SET status = 'CLOSED' WHERE period_id = p_period;

END;

/

GRANT EXECUTE ON app_admin.close_period TO billing_role;

A few facts that help in practice. Roles are disabled inside definer's rights code, so the owner needs direct grants. Since Oracle Database 12c, an invoker's rights unit can use the caller's privileges only if its owner has the INHERIT PRIVILEGES privilege on the caller, or INHERIT ANY PRIVILEGES. Anonymous blocks run with the privileges of whoever executes them.
