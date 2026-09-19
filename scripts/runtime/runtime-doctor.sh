#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
echo "== Runtime Doctor =="
command -v docker >/dev/null && echo "PASS docker" || { echo "FAIL docker"; exit 1; }
docker compose version >/dev/null && echo "PASS docker compose" || { echo "FAIL docker compose"; exit 1; }
test -f "$ROOT/infrastructure/docker/docker-compose.local.yml" && echo "PASS compose manifest" || { echo "FAIL compose manifest"; exit 1; }
test -f "$ROOT/runtime/n8n/n8n-version.yaml" && echo "PASS n8n pin" || { echo "FAIL n8n pin"; exit 1; }
test -f "$ROOT/runtime/mcp/n8n-mcp.yaml" && echo "PASS MCP contract" || { echo "FAIL MCP contract"; exit 1; }
echo "PASS runtime static doctor"
