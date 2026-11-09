# UCP pool tuning for resilience and validation

**Runs where:** Local Oracle Free.

**What it shows:** The article's pool sizing example uses initial/minimum 2, maximum 20, validate-on-borrow, a 5-second idle trust window, 3-second connection wait, 300-second inactive timeout, and borrowed/available metrics. The running service defaults match those values; `UCP_MAX`, `UCP_WAIT_SECONDS`, and `UCP_MIN` can override them.

**Article example:** [article-example.md](article-example.md)

**Runnable code:** [UCP setup and metrics](../../aceu-trust-service/src/main/java/com/example/aceu/Main.java)

**Prerequisites:** Java 21, Maven, Docker, and Docker Compose.

**Run:** `docker compose up --build -d; curl http://localhost:8080/health`

**Expected output:** Health JSON reports UCP min 2, max 20, validation enabled, 3-second wait, and current pool metrics.

**Cleanup:** `docker compose down -v`.

**Article:** [UCP pool tuning for resilience and validation](https://www.imshubh.com/articles/oracle-ace/ucp-pool-tuning-for-resilience-and-validation.html).

**Article date:** 2026-09-18 · **Verified date (maintainer-reported):** Nov 8, 2026. **Local test evidence:** **Tested 2026-11-08 (PST) on macOS arm64, Docker 29.8.0, Temurin OpenJDK 21.0.8, gvenzl/oracle-free:23-slim-faststart (linux/arm64).**
