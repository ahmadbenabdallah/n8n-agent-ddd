#!/usr/bin/env bash
set -euo pipefail
: "${N8N_BASE_URL:?N8N_BASE_URL required}"
: "${N8N_API_KEY:?N8N_API_KEY required}"
mkdir -p artifacts/runtime-evidence
evidence="artifacts/runtime-evidence/phase14-$(date -u +%Y%m%dT%H%M%SZ).jsonl"
record(){ printf '%s\n' "$1" | tee -a "$evidence"; }

if curl -fsS --max-time 8 "$N8N_BASE_URL/healthz/readiness" >/dev/null; then
  record '{"gate":"INT","status":"PASS","evidence":"n8n readiness"}'
else
  record '{"gate":"INT","status":"FAIL","evidence":"n8n readiness failed"}'
  exit 1
fi

# API reachability proves authenticated runtime control access, not workflow certification.
if curl -fsS --max-time 8 -H "X-N8N-API-KEY: $N8N_API_KEY" "$N8N_BASE_URL/api/v1/workflows?limit=1" >/dev/null; then
  record '{"gate":"RT","status":"PASS","evidence":"authenticated n8n API"}'
else
  record '{"gate":"RT","status":"FAIL","evidence":"authenticated n8n API failed"}'
  exit 1
fi

record '{"gate":"E2E","status":"NOT_EXECUTED","reason":"requires configured test workflow and test commerce/channel adapters"}'
record '{"gate":"IDEMP","status":"NOT_EXECUTED","reason":"requires live mutation test fixture"}'
record '{"gate":"RECON","status":"NOT_EXECUTED","reason":"requires live external-outcome fixture"}'
record '{"gate":"DRIFT","status":"NOT_EXECUTED","reason":"requires controlled workflow edit fixture"}'
echo "Live preflight evidence written to $evidence"
