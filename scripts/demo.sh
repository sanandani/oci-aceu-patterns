#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
docker compose up -d --build
for attempt in $(seq 1 90); do
  if docker compose logs service 2>&1 | grep -q 'ACE-U service on'; then break; fi
  if [[ "$attempt" == 90 ]]; then docker compose logs --tail=100; exit 1; fi
  sleep 2
done
printf 'ALTER SESSION SET CURRENT_SCHEMA=ACEU;\nBEGIN aceu_service.score_profile(1001); aceu_service.score_profile(1002); aceu_service.score_profile(1003); END;\n/\n' | docker exec -i oci-aceu-patterns-oracle-1 sqlplus -s aceu_app/aceu_app_local_only@localhost:1521/FREEPDB1
assert_http() {
  local response="$1" expected="$2"
  if [[ "$response" != *"HTTP $expected"* ]]; then printf 'Expected HTTP %s, got:\n%s\n' "$expected" "$response" >&2; exit 1; fi
  printf '%s\n' "$response"
}
printf '\n1/6 health (expected HTTP 200):\n'
health="$(curl -sS -w '\nHTTP %{http_code}\n' http://localhost:8080/health)"
assert_http "$health" 200
printf '\n2/6 consent required (expected HTTP 400):\n'
denied="$(curl -sS -w '\nHTTP %{http_code}\n' -X POST http://localhost:8080/profiles -H 'content-type: application/json' -d '{"displayName":"Synthetic denied","consent":false,"skills":["sql"]}')"
assert_http "$denied" 400
printf '\n3/6 create synthetic profile (expected HTTP 201):\n'
profile_response="$(curl -fsS -w '\nHTTP %{http_code}\n' -X POST http://localhost:8080/profiles -H 'content-type: application/json' --data-binary @scripts/synthetic-profile.json)"
assert_http "$profile_response" 201
profile_id="$(printf '%s\n' "$profile_response" | head -n1 | python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])')"
printf '\n4/6 score (expected vector, per-dimension uncertainty, explanation; HTTP 200):\n'
score="$(curl -fsS -w '\nHTTP %{http_code}\n' "http://localhost:8080/profiles/${profile_id}/score")"
assert_http "$score" 200
printf '\n5/6 rank by relevance, ACE-U trust, and uniqueness (expected HTTP 200):\n'
rank="$(curl -fsS -w '\nHTTP %{http_code}\n' -X POST http://localhost:8080/rank -H 'content-type: application/json' -d "{\"relevanceByProfile\":{\"${profile_id}\":0.95},\"weights\":{\"relevance\":0.5,\"trust\":0.3,\"diversity\":0.2}}")"
assert_http "$rank" 200
printf '\n6/6 contest (expected HTTP 201):\n'
contest="$(curl -fsS -w '\nHTTP %{http_code}\n' -X POST http://localhost:8080/contest -H 'content-type: application/json' -d "{\"profileId\":${profile_id},\"reason\":\"Synthetic demo contest for review\",\"proposedValue\":0.6}")"
assert_http "$contest" 201
printf '\nUnified Audit score-read trail:\n'
audit="$(printf "ALTER SESSION SET CONTAINER=FREEPDB1;\nSET PAGESIZE 50 LINESIZE 220;\nSELECT event_timestamp,dbusername,action_name,object_schema,object_name,sql_text FROM unified_audit_trail WHERE object_schema='ACEU' AND object_name='SCORES' AND action_name='SELECT' ORDER BY event_timestamp DESC FETCH FIRST 25 ROWS ONLY;\n" | docker exec -i oci-aceu-patterns-oracle-1 sqlplus -s / as sysdba)"
printf '%s\n' "$audit"
if ! printf '%s' "$audit" | grep -q 'SELECT a_score'; then printf 'Expected a score SELECT event in Unified Audit trail.\n' >&2; exit 1; fi
