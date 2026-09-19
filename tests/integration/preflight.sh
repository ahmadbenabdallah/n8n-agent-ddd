#!/usr/bin/env bash
set -euo pipefail
: "${N8N_BASE_URL:?N8N_BASE_URL required}"
curl -fsS "$N8N_BASE_URL/healthz/readiness" >/dev/null
echo "LIVE N8N READINESS PASS"
