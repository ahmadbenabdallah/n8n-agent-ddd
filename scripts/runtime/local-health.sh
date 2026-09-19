#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"
docker compose --env-file .env.local -f infrastructure/docker/docker-compose.local.yml ps
echo
curl -fsS "${N8N_BASE_URL:-http://localhost:5678}/healthz" >/dev/null
echo "PASS: n8n health endpoint"
