#!/usr/bin/env bash
set -euo pipefail
: "${OCI_CLI_PROFILE:=DEFAULT}"
echo 'Manual verification: export the wallet from your database service, upload it as a versioned OCI Vault secret, and distribute only to authorized workloads.'
echo 'Do not save wallet archives in this repository or print secret contents.'
