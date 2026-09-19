#!/usr/bin/env bash
set -euo pipefail
bash scripts/runtime/local-stack-doctor.sh
docker compose -f infrastructure/docker/docker-compose.local.yml up -d
echo "Local n8n + PostgreSQL stack requested."
