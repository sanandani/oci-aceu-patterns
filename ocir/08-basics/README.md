# OCIR basics: push/pull, private repos, auth tokens

**What it shows:** Terraform creates a private OCIR repository; commands use placeholder region/namespace and short-lived auth-token guidance.

**Runnable code:** [Private OCIR repository module](../../terraform/modules/ocir/main.tf) and [push/pull example](ocir-example.sh)

**Prerequisites:** See the run command below. OCI examples require an OCI tenancy and CLI configured with placeholders; local examples require Java 21, Maven, Docker, and Docker Compose as applicable.

**Run:** `terraform -chdir=terraform init && terraform -chdir=terraform validate`. To push the container, copy `terraform/terraform.tfvars.example` to ignored `terraform/local.tfvars`, replace placeholders, then run `./ocir/08-basics/ocir-example.sh` with `OCIR_REGION_KEY`, `OCIR_NAMESPACE`, and `OCIR_USERNAME`; the script prompts for the auth token without echoing it.

**Expected output:** The command succeeds and reports the created resource, successful connection, or Terraform validation. For manual steps, record the console verification result locally.

**Cleanup:** For local containers run `docker compose down -v`. For OCI resources, run `terraform -chdir=terraform destroy` only after reviewing the plan and remove any manually-created Identity Domain policies or secrets.

**Article:** [OCIR basics: push/pull, private repos, auth tokens](https://www.imshubh.com/blog.html#oracle-ace) (TODO: replace with the direct article URL).

**Source fidelity:** The referenced article-specific `.docx` source was not present in this workspace. This runnable example is reconstructed from the published article topic; replace/compare it with the source document when available.

**TODO tested-on:** ____________________
