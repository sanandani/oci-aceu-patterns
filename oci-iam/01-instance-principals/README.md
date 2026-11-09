# Using OCI Instance Principals without leaking credentials

**Runs where:** OCI / Terraform.

**What it shows:** Instance principal Java SDK example and compartment-plus-tag dynamic-group rule.

**Article example:** [article-example.md](article-example.md)

**Prerequisites:** OCI CLI/Terraform and configured OCI tenancy.

**Run:** `terraform -chdir=../../terraform init && terraform -chdir=../../terraform validate`

**Expected output:** Terraform validates the portfolio configuration; apply requires OCI placeholders.

**Cleanup:** `terraform -chdir=../../terraform destroy only after reviewing the plan; remove manually created resources`.

**Article:** [Using OCI Instance Principals without leaking credentials](https://www.imshubh.com/articles/oracle-ace/using-oci-instance-principals-without-leaking-credentials.html).

**Article date:** 2025-08-19 · **Verified date (maintainer-reported):** Nov 8, 2026.
