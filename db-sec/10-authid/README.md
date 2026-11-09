# Oracle DB: invoker's vs definer's rights for least-privilege code

**Runs where:** Local Oracle Free.

**What it shows:** Article AUTHID CURRENT_USER and narrow ACCESSIBLE BY example, adapted into the runnable schema script.

**Article example:** [article-example.md](article-example.md)

**Prerequisites:** Docker Compose and Oracle Database Free.

**Run:** `docker compose up -d oracle && docker compose exec -T oracle sqlplus -s aceu/aceu_local_only@localhost:1521/FREEPDB1 < db-sec/10-authid/authid.sql`

**Expected output:** The script prints the invoker procedure output and confirms the definer package changed the period status.

**Cleanup:** `docker compose down -v`.

**Article:** [Oracle DB: invoker's vs definer's rights for least-privilege code](https://www.imshubh.com/articles/oracle-ace/oracle-db-invoker-s-vs-definer-s-rights-for-least-privilege-code.html).

**Article date:** 2026-05-21 · **Verified date (maintainer-reported):** Nov 8, 2026. **Local test evidence:** **Tested 2026-11-08 (PST) on macOS arm64, Docker 29.8.0, Temurin OpenJDK 21.0.8, gvenzl/oracle-free:23-slim-faststart (linux/arm64).**
