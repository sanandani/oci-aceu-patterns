# Identity Domains: SAML/OIDC federation setup notes

**What it shows:** Console runbook covers identity provider metadata, mapping, and a non-admin test assignment.

**Prerequisites:** See the run command below. OCI examples require an OCI tenancy and CLI configured with placeholders; local examples require Java 21, Maven, Docker, and Docker Compose as applicable.

**Run:** `Manual verification in OCI Identity Domains console.`

**Expected output:** The command succeeds and reports the created resource, successful connection, or Terraform validation. For manual steps, record the console verification result locally.

**Cleanup:** For local containers run `docker compose down -v`. For OCI resources, run `terraform -chdir=terraform destroy` only after reviewing the plan and remove any manually-created Identity Domain policies or secrets.

**Article:** [Identity Domains: SAML/OIDC federation setup notes](https://www.imshubh.com/blog.html#oracle-ace) (TODO: replace with the direct article URL).

**Source fidelity:** The referenced article-specific `.docx` source was not present in this workspace. This runnable example is reconstructed from the published article topic; replace/compare it with the source document when available.

**TODO tested-on:** ____________________
