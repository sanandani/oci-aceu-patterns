# Compartment design and movement: policy implications

**Runs where:** OCI / Terraform + manual move review.

**What it shows:** Ancestor policy and compartment movement implications, including access checks before and after a move.

**Article example:** [article-example.md](article-example.md)

**Prerequisites:** OCI CLI/Terraform and configured OCI tenancy.

**Run:** `terraform -chdir=../../terraform validate; review article-example.md for the move runbook.`

**Expected output:** Terraform validates; compartment movement verification is manual.

**Cleanup:** `terraform -chdir=../../terraform destroy only after reviewing the plan; remove manually created resources`.

**Article:** [Compartment design and movement: policy implications](https://www.imshubh.com/articles/oracle-ace/compartment-design-and-movement-policy-implications.html).

**Verification status:** Not yet applied to a live tenancy.
