# Minimal Java container on OCI with TLS to DB

**Runs where:** Local container build; OCI deployment is manual.

**What it shows:** Article Dockerfile and Podman hardening commands; repo image build uses the flagship service container.

**Article example:** [article-example.md](article-example.md)

**Prerequisites:** Java 21, Maven, Docker Compose, and Oracle Database Free.

**Run:** `docker compose build service`

**Expected output:** Docker reports a successful image build.

**Cleanup:** `docker compose down -v`.

**Article:** [Minimal Java container on OCI with TLS to DB](https://www.imshubh.com/blog.html#oracle-ace).

**TODO tested-on:** ____________________
