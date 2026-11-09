# Unified Auditing: practical policies and trail hygiene

**Runs where:** Local Oracle Free.

**What it shows:** Article Unified Auditing baseline/custom policies and managed trail hygiene; local file is executable against the demo DB.

**Article example:** [article-example.md](article-example.md)

**Prerequisites:** Docker Compose and Oracle Database Free.

**Run:** `docker compose up -d oracle && docker compose exec -T oracle sqlplus -s / as sysdba < db-sec/12-unified-audit/audit.sql`

**Expected output:** Queries show enabled policies and audit trail rows.

**Cleanup:** `docker compose down -v`.

**Article:** [Unified Auditing: practical policies and trail hygiene](https://www.imshubh.com/blog.html#oracle-ace).

**TODO tested-on:** ____________________
