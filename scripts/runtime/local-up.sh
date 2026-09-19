#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"
[[ -f .env.local ]] || "$ROOT/scripts/bootstrap/local-env.sh"
set -a
source .env.local
set +a
docker compose --env-file .env.local -f infrastructure/docker/docker-compose.local.yml up -d
