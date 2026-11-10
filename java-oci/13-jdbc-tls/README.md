# JDBC/UCP to Oracle over TLS or mTLS with wallets

**Runs where:** Local Oracle Free (plain TCP); TLS settings documented.

**What it shows:** Article UCP alias/password example and NETWORK_PROTOCOL proof; local compose remains plain TCP.

**Article example:** [article-example.md](article-example.md)

**Prerequisites:** Java 21, Maven, Docker Compose, and Oracle Database Free.

**Run:** `Run the JDBC integration test from the repository root; see TlsNotes.md for TLS/wallet settings.`

**Expected output:** Local probe uses TCP; a TLS-enabled endpoint should report tcps.

**Cleanup:** `docker compose down -v`.

**Article:** [JDBC/UCP to Oracle over TLS or mTLS with wallets](https://www.imshubh.com/articles/oracle-ace/jdbc-ucp-to-oracle-over-tls-or-mtls-with-wallets.html).

**Verification status:** Tested locally on 2026-11-09 over plain TCP; TLS/wallet configuration was not exercised.
