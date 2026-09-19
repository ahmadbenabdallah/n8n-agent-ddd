#!/usr/bin/env bash
set -euo pipefail

: "${PHASE16_ENVIRONMENT:=}"
: "${CONFIRM_PHASE16:=}"

[[ "$PHASE16_ENVIRONMENT" == "staging" ]] || { echo "BLOCKED: PHASE16_ENVIRONMENT=staging required"; exit 2; }
[[ "$CONFIRM_PHASE16" == "YES" ]] || { echo "BLOCKED: CONFIRM_PHASE16=YES required"; exit 2; }

required_vars=(
  N8N_VERSION
  DATABASE_PROVIDER
  DATABASE_URL
  N8N_BASE_URL
  N8N_PROJECT_NAME
)

for var in "${required_vars[@]}"; do
  [[ -n "${!var:-}" ]] || { echo "BLOCKED: missing $var"; exit 2; }
done

echo "Phase 16 staging preflight contract: PASS"
echo "No runtime mutation was performed."
