#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

test -f platform/ownership/policy.ts
test -f platform/operator/authorization.ts
test -f spec/ownership/operator-ownership.yaml
test -f spec/operator/runtime-binding.yaml
test -f spec/operator/upgrade-ownership.yaml
test -f docs/architecture/operator-ownership.md

grep -q 'WF-01, WF-10, WF-15, WF-20' spec/ownership/operator-ownership.yaml
grep -q 'WF-10 remains authoritative' spec/operator/runtime-binding.yaml
grep -q 'No custom UI assumption' docs/architecture/operator-ownership.md
grep -q 'Incompatible extension is quarantined' spec/operator/upgrade-ownership.yaml

echo 'OPERATOR OWNERSHIP PASS'
