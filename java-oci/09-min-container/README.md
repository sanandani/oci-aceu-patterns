# Minimal Java container on OCI with TLS to DB

**Runs where:** Local container build; OCI deployment is manual.

**What it shows:** Article Dockerfile and Podman hardening commands; repo image build uses the flagship service container.

**Article example:** [article-example.md](article-example.md)

**Prerequisites:** Java 21, Maven, Docker Compose, and Oracle Database Free.

**Run:** `docker compose build service`

**Expected output:** Docker reports a successful image build.

**Cleanup:** `docker compose down -v`.

**Article:** [Minimal Java container on OCI with TLS to DB](https://www.imshubh.com/articles/oracle-ace/minimal-java-container-on-oci-with-tls-to-db.html).

**Article date:** 2026-04-14 · **Verified date (maintainer-reported):** Nov 8, 2026. **Local test evidence:** **Tested 2026-11-08 (PST) on macOS arm64, Docker 29.8.0, Temurin OpenJDK 21.0.8, gvenzl/oracle-free:23-slim-faststart (linux/arm64).**
