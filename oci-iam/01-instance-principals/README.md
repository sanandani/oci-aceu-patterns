# Using OCI Instance Principals without leaking credentials

**What it shows:** OCI SDK uses instance principals; see terraform/modules/ampere and README for deployment.

**Runnable code:** [Ampere and instance-principal deployment module](../../terraform/modules/ampere/main.tf)

**Prerequisites:** See the run command below. OCI examples require an OCI tenancy and CLI configured with placeholders; local examples require Java 21, Maven, Docker, and Docker Compose as applicable.

**Run:** `Terraform deploys a tagged Ampere instance; runtime principal configuration is documented in the service container.`

**Expected output:** The command succeeds and reports the created resource, successful connection, or Terraform validation. For manual steps, record the console verification result locally.

**Cleanup:** For local containers run `docker compose down -v`. For OCI resources, run `terraform -chdir=terraform destroy -var-file=local.tfvars` only after reviewing the plan and remove any manually-created Identity Domain policies or secrets.

**Article:** [Using OCI Instance Principals without leaking credentials](https://www.imshubh.com/blog.html#oracle-ace) (TODO: replace with the direct article URL).

**Source fidelity:** The referenced article-specific `.docx` source was not present in this workspace. This runnable example is reconstructed from the published article topic; replace/compare it with the source document when available.

**TODO tested-on:** ____________________
