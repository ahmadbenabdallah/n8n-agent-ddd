#!/usr/bin/env bash
set -euo pipefail
docker compose -f infrastructure/docker/docker-compose.local.yml down
echo "Containers stopped. Named volumes were preserved."
