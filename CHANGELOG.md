# Changelog

## 1.0.0 — 2026-11-09

- Release the synthetic-data-only ACE-U service for Java 21, Helidon SE, and Oracle Database 23ai Free, including vector-based uniqueness, scoring explanations, consent checks, and Unified Auditing.
- Include 16 article folders, OCI Terraform modules, an offline-fixture-capable read-only OCI scanner, and the static Pages portfolio.
- Make the Oracle integration test mandatory in Maven and require CI to report one run with zero skips.

### Verification status

- Local Oracle demos were tested; the JDBC example used plain TCP and did not exercise TLS or wallet configuration.
- Terraform formatting and validation pass in CI; Terraform has not been applied to a live tenancy.
- Console- and edition-dependent examples remain manual runbooks and have not yet been executed.
