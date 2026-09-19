#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

test -f "$ROOT/spec/deployment/provider-neutral-runtime.yaml"
test -f "$ROOT/spec/runtime/deployment-modes.yaml"
test -f "$ROOT/infrastructure/docker/docker-compose.n8n-only.yml"
test -f "$ROOT/infrastructure/environments/local/.env.example"
test -f "$ROOT/infrastructure/environments/remote-n8n/.env.example"
test -x "$ROOT/scripts/runtime/runtime-config-check.sh"
test -x "$ROOT/scripts/deployment/validate-provider-config.sh"

grep -q 'n8n_is_execution_runtime' "$ROOT/spec/deployment/provider-neutral-runtime.yaml"
grep -q 'n8n_remote' "$ROOT/spec/runtime/deployment-modes.yaml"
grep -q 'N8N_ENCRYPTION_KEY' "$ROOT/infrastructure/docker/docker-compose.n8n-only.yml"
grep -q 'WEBHOOK_URL' "$ROOT/infrastructure/docker/docker-compose.n8n-only.yml"

echo "PROVIDER-NEUTRAL RUNTIME PASS"
