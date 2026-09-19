#!/usr/bin/env bash
set -euo pipefail

: "${N8N_BASE_URL:=http://127.0.0.1:5678}"
: "${DATABASE_URL:?DATABASE_URL is required}"
: "${EVIDENCE_DIR:=runtime/evidence/phase-15.0}"

mkdir -p "$EVIDENCE_DIR"

if [[ "${ALLOW_LIVE_RUNTIME:-NO}" != "YES" ]]; then
  cat > "$EVIDENCE_DIR/preflight.json" <<EOF
{"status":"NOT_EXECUTED","reason":"Set ALLOW_LIVE_RUNTIME=YES to execute live staging checks","n8n_base_url":"${N8N_BASE_URL}"}
EOF
  echo "NOT_EXECUTED: live runtime execution is opt-in."
  exit 2
fi

command -v curl >/dev/null 2>&1 || { echo "ERROR: curl required"; exit 1; }
command -v psql >/dev/null 2>&1 || { echo "ERROR: psql required"; exit 1; }

N8N_HTTP="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 10 "$N8N_BASE_URL/healthz" || true)"

if [[ "$N8N_HTTP" != "200" ]]; then
  cat > "$EVIDENCE_DIR/n8n-readiness.json" <<EOF
{"status":"FAIL","http_status":"${N8N_HTTP}","base_url":"${N8N_BASE_URL}"}
EOF
  echo "FAIL: n8n health endpoint did not return HTTP 200."
  exit 1
fi

psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -Atc "select 1;" >/dev/null
printf '%s\n' '{"status":"PASS","database":"reachable"}' > "$EVIDENCE_DIR/postgres-readiness.json"
printf '%s\n' "{\"status\":\"PASS\",\"http_status\":${N8N_HTTP}}" > "$EVIDENCE_DIR/n8n-readiness.json"
printf '%s\n' "{\"status\":\"PASS\",\"n8n_base_url\":\"${N8N_BASE_URL}\"}" > "$EVIDENCE_DIR/preflight.json"

echo "PASS: live n8n and PostgreSQL readiness."
echo "Next: project binding, workflow inventory, contracts and smoke test."
