#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
"$ROOT/scripts/bootstrap/local-preflight.sh"
"$ROOT/scripts/bootstrap/local-env.sh"
"$ROOT/scripts/runtime/runtime-doctor.sh"
"$ROOT/scripts/runtime/local-up.sh"
echo "Waiting for n8n..."
for i in $(seq 1 60); do
  if curl -fsS "${N8N_BASE_URL:-http://localhost:5678}/healthz" >/dev/null 2>&1; then
    echo "PASS: n8n is healthy"
    exit 0
  fi
  sleep 2
done
echo "ERROR: n8n did not become healthy within timeout"
exit 1
