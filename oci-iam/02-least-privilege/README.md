# Least-privilege IAM policies for workloads (compartment-first)

**Runs where:** OCI / Terraform.

**What it shows:** Compartment-first runtime and operator policy statements, with the broad tenancy grant shown only as a review anti-pattern.

**Article example:** [article-example.md](article-example.md)

**Prerequisites:** OCI CLI/Terraform and configured OCI tenancy.

**Run:** `terraform -chdir=../../terraform validate`

**Expected output:** Terraform configuration validates; policy statements are in article-example.md.

**Cleanup:** `terraform -chdir=../../terraform destroy only after reviewing the plan; remove manually created resources`.

**Article:** [Least-privilege IAM policies for workloads (compartment-first)](https://www.imshubh.com/articles/oracle-ace/least-privilege-iam-policies-for-workloads-compartment-first.html).

**Verification status:** Not yet applied to a live tenancy.
