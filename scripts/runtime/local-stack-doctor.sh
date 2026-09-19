#!/usr/bin/env bash
set -euo pipefail
command -v docker >/dev/null || { echo "Docker is required" >&2; exit 1; }
docker compose version >/dev/null || { echo "Docker Compose is required" >&2; exit 1; }
docker compose -f infrastructure/docker/docker-compose.local.yml config >/dev/null
echo "LOCAL STACK CONTRACT PASS"
