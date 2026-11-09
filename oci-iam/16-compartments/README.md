# Compartment design and movement: policy implications

**What it shows:** Terraform creates a dedicated child compartment and demonstrates compartment-scoped policies; movement is a console review.

**Runnable code:** [Compartment module](../../terraform/modules/compartment/main.tf)

**Prerequisites:** See the run command below. OCI examples require an OCI tenancy and CLI configured with placeholders; local examples require Java 21, Maven, Docker, and Docker Compose as applicable.

**Run:** `terraform -chdir=terraform init && terraform -chdir=terraform validate`. To provision in your tenancy, copy `terraform/terraform.tfvars.example` to ignored `terraform/local.tfvars`, replace placeholders with your account/network/image values, inspect `terraform -chdir=terraform plan -var-file=local.tfvars`, then apply only after reviewing the resources.

**Expected output:** The command succeeds and reports the created resource, successful connection, or Terraform validation. For manual steps, record the console verification result locally.

**Cleanup:** For local containers run `docker compose down -v`. For OCI resources, run `terraform -chdir=terraform destroy -var-file=local.tfvars` only after reviewing the plan and remove any manually-created Identity Domain policies or secrets.

**Article:** [Compartment design and movement: policy implications](https://www.imshubh.com/blog.html#oracle-ace) (TODO: replace with the direct article URL).

**Source fidelity:** The referenced article-specific `.docx` source was not present in this workspace. This runnable example is reconstructed from the published article topic; replace/compare it with the source document when available.

**TODO tested-on:** ____________________
