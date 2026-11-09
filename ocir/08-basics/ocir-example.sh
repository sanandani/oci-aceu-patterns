#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
: "${OCIR_REGION_KEY:?Set the region key, for example phx}"
: "${OCIR_NAMESPACE:?Set the tenancy namespace placeholder from OCI}"
: "${OCIR_USERNAME:?Set your OCI user name}"
: "${OCIR_REPOSITORY:=aceu-trust-service}"
: "${OCIR_TAG:=local-demo}"
read -r -s -p 'OCIR auth token: ' OCIR_TOKEN
printf '\n'
printf '%s' "$OCIR_TOKEN" | docker login "${OCIR_REGION_KEY}.ocir.io" -u "${OCIR_NAMESPACE}/${OCIR_USERNAME}" --password-stdin
unset OCIR_TOKEN
docker build -t "${OCIR_REGION_KEY}.ocir.io/${OCIR_NAMESPACE}/${OCIR_REPOSITORY}:${OCIR_TAG}" "$ROOT/aceu-trust-service"
docker push "${OCIR_REGION_KEY}.ocir.io/${OCIR_NAMESPACE}/${OCIR_REPOSITORY}:${OCIR_TAG}"
