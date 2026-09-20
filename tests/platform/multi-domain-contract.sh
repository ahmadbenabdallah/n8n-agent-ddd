#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[ ! -d "${ROOT:-.}/docs" ] || test -f "${ROOT:-.}/docs/domain/multi-domain-platform.md"
files=(
  spec/releases/phase-20.0-multi-domain-platform.yaml
  spec/domains/domain-pack-contract.yaml
  spec/platform/port-contract.yaml
  spec/platform/domain-isolation-contract.yaml
  spec/platform/channel-commerce-matrix.yaml
  spec/deployment/domain-profile-contract.yaml
  scripts/platform/validate-domain-pack.sh
  scripts/platform/validate-isolation.sh
)
for f in "${files[@]}"; do
  test -f "$ROOT/$f" || { echo "MISSING: $f"; exit 1; }
done
for f in scripts/platform/*.sh; do
  bash -n "$ROOT/$f"
done
bash "$ROOT/scripts/platform/validate-isolation.sh"
grep -q 'cross_domain_access_denied_by_default: true' "$ROOT/spec/releases/phase-20.0-multi-domain-platform.yaml"
grep -q 'channel_and_commerce_are_independent_axes: true' "$ROOT/spec/platform/channel-commerce-matrix.yaml"
grep -q 'no_1_0_claimed: true' "$ROOT/spec/releases/phase-20.0-multi-domain-platform.yaml"
grep -q 'live_multi_domain_execution: "NOT_EXECUTED"' "$ROOT/spec/releases/phase-20.0-multi-domain-platform.yaml"
echo "Phase 20 contract successful."
