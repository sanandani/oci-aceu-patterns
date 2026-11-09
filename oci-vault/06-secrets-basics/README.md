# Practical secrets with OCI Vault: creation, rotation, and usage

**Runs where:** OCI / Terraform.

**What it shows:** Vault secret read example, narrow secret-bundle policy, and rotation guidance.

**Article example:** [article-example.md](article-example.md)

**Prerequisites:** OCI CLI/Terraform and configured OCI tenancy.

**Run:** `terraform -chdir=../../terraform validate`

**Expected output:** Terraform validates; secret creation and rotation require OCI.

**Cleanup:** `terraform -chdir=../../terraform destroy only after reviewing the plan; remove manually created resources`.

**Article:** [Practical secrets with OCI Vault: creation, rotation, and usage](https://www.imshubh.com/articles/oracle-ace/practical-secrets-with-oci-vault-creation-rotation-and-usage.html).

**Article date:** 2026-01-23 · **Verified date (maintainer-reported):** Nov 8, 2026.
