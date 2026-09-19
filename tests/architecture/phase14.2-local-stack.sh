#!/usr/bin/env bash
set -euo pipefail
test -f infrastructure/docker/docker-compose.local.yml
test -f spec/runtime/local-runtime-stack.yaml
test -f spec/deployment/environment-matrix.yaml
grep -q '127.0.0.1:5678:5678' infrastructure/docker/docker-compose.local.yml
grep -q 'n8n_data:' infrastructure/docker/docker-compose.local.yml
grep -q 'postgres_data:' infrastructure/docker/docker-compose.local.yml
echo "PHASE 14.2 LOCAL STACK PASS"
