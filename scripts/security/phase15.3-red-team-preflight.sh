#!/usr/bin/env bash
set -euo pipefail

: "${EVIDENCE_DIR:=runtime/evidence/phase-15.3}"
mkdir -p "$EVIDENCE_DIR"

if [[ "${ALLOW_LIVE_REDTEAM:-NO}" != "YES" ]]; then
  printf '%s\n' '{"status":"NOT_EXECUTED","reason":"Set ALLOW_LIVE_REDTEAM=YES for live staging security tests"}' > "$EVIDENCE_DIR/evidence-summary.json"
  echo "NOT_EXECUTED: live red-team testing is opt-in."
  exit 2
fi

command -v curl >/dev/null 2>&1 || { echo "ERROR: curl required"; exit 1; }

: "${N8N_BASE_URL:=http://127.0.0.1:5678}"

status="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 10 "$N8N_BASE_URL/healthz" || true)"
if [[ "$status" != "200" ]]; then
  printf '%s\n' "{\"status\":\"FAIL\",\"n8n_http_status\":\"${status}\"}" > "$EVIDENCE_DIR/preflight.json"
  echo "FAIL: n8n staging runtime is not healthy."
  exit 1
fi

printf '%s\n' "{\"status\":\"PASS\",\"n8n_http_status\":\"${status}\"}" > "$EVIDENCE_DIR/preflight.json"
echo "PASS: red-team runtime preflight."
