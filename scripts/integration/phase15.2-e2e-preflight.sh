#!/usr/bin/env bash
set -euo pipefail

: "${EVIDENCE_DIR:=runtime/evidence/phase-15.2}"
: "${CHANNEL_BASE_URL:=}"
: "${COMMERCE_BASE_URL:=}"

mkdir -p "$EVIDENCE_DIR"

if [[ "${ALLOW_LIVE_E2E:-NO}" != "YES" ]]; then
  printf '%s\n' '{"status":"NOT_EXECUTED","reason":"Set ALLOW_LIVE_E2E=YES to execute staging E2E"}' > "$EVIDENCE_DIR/evidence-summary.json"
  echo "NOT_EXECUTED: live E2E is opt-in."
  exit 2
fi

command -v curl >/dev/null 2>&1 || { echo "ERROR: curl required"; exit 1; }

if [[ -z "$CHANNEL_BASE_URL" || -z "$COMMERCE_BASE_URL" ]]; then
  echo "NOT_EXECUTED: test channel and commerce endpoints must be configured."
  exit 2
fi

channel_status="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 10 "$CHANNEL_BASE_URL/health" || true)"
commerce_status="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 10 "$COMMERCE_BASE_URL/health" || true)"

printf '%s\n' "{\"channel_http_status\":\"${channel_status}\",\"commerce_http_status\":\"${commerce_status}\"}" > "$EVIDENCE_DIR/preflight.json"

if [[ "$channel_status" != "200" || "$commerce_status" != "200" ]]; then
  echo "FAIL: channel or commerce test endpoint is not healthy."
  exit 1
fi

echo "PASS: E2E test dependencies are reachable."
