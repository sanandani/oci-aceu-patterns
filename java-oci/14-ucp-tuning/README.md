# UCP pool tuning for resilience and validation

**What it shows:** Runnable UCP configuration uses bounded min/max, validate-on-borrow, 5-second wait, and metrics endpoint.

**Runnable code:** [UCP configuration and metrics endpoint](../../aceu-trust-service/src/main/java/com/example/aceu/Main.java)

**Prerequisites:** See the run command below. OCI examples require an OCI tenancy and CLI configured with placeholders; local examples require Java 21, Maven, Docker, and Docker Compose as applicable.

**Run:** `docker compose up --build; curl http://localhost:8080/health`

**Expected output:** The command succeeds and reports the created resource, successful connection, or Terraform validation. For manual steps, record the console verification result locally.

**Cleanup:** For local containers run `docker compose down -v`. For OCI resources, run `terraform -chdir=terraform destroy` only after reviewing the plan and remove any manually-created Identity Domain policies or secrets.

**Article:** [UCP pool tuning for resilience and validation](https://www.imshubh.com/blog.html#oracle-ace) (TODO: replace with the direct article URL).

**Source fidelity:** The referenced article-specific `.docx` source was not present in this workspace. This runnable example is reconstructed from the published article topic; replace/compare it with the source document when available.

**TODO tested-on:** ____________________
