#!/usr/bin/env bash
set -euo pipefail

: "${EVIDENCE_DIR:=runtime/evidence/phase-15.5}"
mkdir -p "$EVIDENCE_DIR"

if [[ "${ALLOW_LIVE_LOAD:-NO}" != "YES" ]]; then
  printf '%s\n' '{"status":"NOT_EXECUTED","reason":"Set ALLOW_LIVE_LOAD=YES for controlled staging load tests"}' > "$EVIDENCE_DIR/evidence-summary.json"
  echo "NOT_EXECUTED: live load testing is opt-in."
  exit 2
fi

command -v curl >/dev/null 2>&1 || { echo "ERROR: curl required"; exit 1; }
: "${N8N_BASE_URL:=http://127.0.0.1:5678}"

status="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 10 "$N8N_BASE_URL/healthz" || true)"

if [[ "$status" != "200" ]]; then
  printf '%s\n' "{\"status\":\"FAIL\",\"n8n_http_status\":\"${status}\"}" > "$EVIDENCE_DIR/preflight.json"
  echo "FAIL: n8n runtime is not healthy."
  exit 1
fi

printf '%s\n' "{\"status\":\"PASS\",\"n8n_http_status\":\"${status}\",\"production_load\":\"forbidden\"}" > "$EVIDENCE_DIR/preflight.json"
echo "PASS: Phase 15.5 load/resilience preflight."
