#!/usr/bin/env bash
set -euo pipefail
test -f spec/deployment/runtime-provider.yaml
test -f spec/deployment/runtime-config.schema.yaml
test -f spec/deployment/provider-adapters.yaml
test -f infrastructure/docker/docker-compose.local.yml
test -f infrastructure/docker/docker-compose.n8n-only.yml
test -f infrastructure/providers/railway/README.md
grep -q 'provider-neutral' spec/deployment/runtime-provider.yaml
grep -q 'N8N_ENCRYPTION_KEY' spec/deployment/runtime-config.schema.yaml
grep -q 'persistent_n8n_data' spec/deployment/provider-adapters.yaml
echo "PHASE13 RUNTIME PROVIDER PASS"
