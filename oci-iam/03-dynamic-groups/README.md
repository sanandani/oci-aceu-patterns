# Dynamic groups with tag-based scoping (illustrative patterns)

**Runs where:** OCI / Terraform.

**What it shows:** ALL/ANY tag-scoped dynamic-group rule and membership rollout checklist.

**Article example:** [article-example.md](article-example.md)

**Prerequisites:** OCI CLI/Terraform and configured OCI tenancy.

**Run:** `terraform -chdir=../../terraform validate`

**Expected output:** Terraform validates; verify effective membership manually after propagation.

**Cleanup:** `terraform -chdir=../../terraform destroy only after reviewing the plan; remove manually created resources`.

**Article:** [Dynamic groups with tag-based scoping (illustrative patterns)](https://www.imshubh.com/articles/oracle-ace/dynamic-groups-with-tag-based-scoping-illustrative-patterns.html).

**Verification status:** Not yet applied to a live tenancy.
