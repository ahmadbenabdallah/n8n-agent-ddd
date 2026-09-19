#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
required=(
  "$ROOT/spec/configuration/customer-runtime-config.yaml"
  "$ROOT/spec/extensions/customer-extension-contract.yaml"
  "$ROOT/spec/customization/ownership-and-upgrade.yaml"
  "$ROOT/spec/runtime/customer-runtime-surface.yaml"
  "$ROOT/platform/configuration/validation.ts"
  "$ROOT/platform/configuration/resolver.ts"
  "$ROOT/platform/extensions/registry.ts"
  "$ROOT/platform/customization/policy.ts"
)
for f in "${required[@]}"; do test -f "$f" || { echo "MISSING $f"; exit 1; }; done
for key in WF-01 WF-10 WF-15 WF-20; do grep -q "$key" "$ROOT/spec/extensions/customer-extension-contract.yaml" || exit 1; done
grep -q 'raw_env_exposure: false' "$ROOT/spec/runtime/customer-runtime-surface.yaml"
grep -q 'commerce.authorization' "$ROOT/spec/extensions/customer-extension-contract.yaml"
grep -q 'N8N_ENCRYPTION_KEY' "$ROOT/spec/configuration/customer-runtime-config.yaml"
echo 'CUSTOMER RUNTIME SURFACE PASS'
