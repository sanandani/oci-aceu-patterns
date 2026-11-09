# Oracle DB: invoker's vs definer's rights for least-privilege code

**What it shows:** Runnable PL/SQL package rights example is in sql/authid.sql; flagship service uses AUTHID CURRENT_USER shared logic and a narrow ACCESSIBLE BY wrapper.

**Runnable code:** [Runnable PL/SQL example](authid.sql)

**Prerequisites:** See the run command below. OCI examples require an OCI tenancy and CLI configured with placeholders; local examples require Java 21, Maven, Docker, and Docker Compose as applicable.

**Run:** `sqlplus user@FREEPDB1 @sql/authid.sql`

**Expected output:** The command succeeds and reports the created resource, successful connection, or Terraform validation. For manual steps, record the console verification result locally.

**Cleanup:** For local containers run `docker compose down -v`. For OCI resources, run `terraform -chdir=terraform destroy` only after reviewing the plan and remove any manually-created Identity Domain policies or secrets.

**Article:** [Oracle DB: invoker's vs definer's rights for least-privilege code](https://www.imshubh.com/blog.html#oracle-ace) (TODO: replace with the direct article URL).

**Source fidelity:** The referenced article-specific `.docx` source was not present in this workspace. This runnable example is reconstructed from the published article topic; replace/compare it with the source document when available.

**TODO tested-on:** ____________________
