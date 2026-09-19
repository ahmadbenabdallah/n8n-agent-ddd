#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
grep -q 'cross_domain_calls: deny' "$ROOT/spec/platform/domain-isolation-contract.yaml"
grep -q 'explicit_cross_domain_contract_required: true' "$ROOT/spec/platform/domain-isolation-contract.yaml"
grep -q 'authorization_required: true' "$ROOT/spec/platform/domain-isolation-contract.yaml"
grep -q 'audit_required: true' "$ROOT/spec/platform/domain-isolation-contract.yaml"
echo "Domain isolation contract is valid."
