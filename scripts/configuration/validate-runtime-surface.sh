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
# The protected set is the domain's, declared in its registry; the platform
# contract only states where it comes from.
grep -q 'protected_workflows: declared_by_domain_registry' "$ROOT/spec/extensions/customer-extension-contract.yaml"
"$ROOT/scripts/security/verify-protected-set.sh" >/dev/null
grep -q 'raw_env_exposure: false' "$ROOT/spec/runtime/customer-runtime-surface.yaml"
grep -q 'commerce.authorization' "$ROOT/spec/extensions/customer-extension-contract.yaml"
grep -q 'N8N_ENCRYPTION_KEY' "$ROOT/spec/configuration/customer-runtime-config.yaml"
echo 'CUSTOMER RUNTIME SURFACE PASS'
