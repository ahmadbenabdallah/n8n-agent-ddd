#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

test -f platform/ownership/policy.ts
test -f platform/operator/authorization.ts
test -f spec/ownership/operator-ownership.yaml
test -f spec/operator/runtime-binding.yaml
test -f spec/operator/upgrade-ownership.yaml
[ ! -d "${ROOT:-.}/docs" ] || test -f docs/architecture/operator-ownership.md

grep -q 'protected_workflows_are_declared_by_the_domain' spec/ownership/operator-ownership.yaml
grep -q 'authorization role remains authoritative' spec/operator/runtime-binding.yaml
[ ! -d "${ROOT:-.}/docs" ] || grep -q 'No custom UI assumption' docs/architecture/operator-ownership.md
grep -q 'Incompatible extension is quarantined' spec/operator/upgrade-ownership.yaml

echo 'OPERATOR OWNERSHIP PASS'
