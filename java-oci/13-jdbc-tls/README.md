# JDBC/UCP to Oracle over TLS or mTLS with wallets

**What it shows:** Runnable local plain-TCP JDBC probe; TLS/wallet JVM settings are documented for a TLS-enabled DB endpoint.

**Runnable code:** [TLS notes](TlsNotes.md) and the [JDBC/UCP service](../../aceu-trust-service/src/main/java/com/example/aceu/Main.java)

**Prerequisites:** See the run command below. OCI examples require an OCI tenancy and CLI configured with placeholders; local examples require Java 21, Maven, Docker, and Docker Compose as applicable.

**Run:** `mvn -f aceu-trust-service/pom.xml test; plain TCP in local compose.`

**Expected output:** The command succeeds and reports the created resource, successful connection, or Terraform validation. For manual steps, record the console verification result locally.

**Cleanup:** For local containers run `docker compose down -v`. For OCI resources, run `terraform -chdir=terraform destroy` only after reviewing the plan and remove any manually-created Identity Domain policies or secrets.

**Article:** [JDBC/UCP to Oracle over TLS or mTLS with wallets](https://www.imshubh.com/blog.html#oracle-ace) (TODO: replace with the direct article URL).

**Source fidelity:** The referenced article-specific `.docx` source was not present in this workspace. This runnable example is reconstructed from the published article topic; replace/compare it with the source document when available.

**TODO tested-on:** ____________________
