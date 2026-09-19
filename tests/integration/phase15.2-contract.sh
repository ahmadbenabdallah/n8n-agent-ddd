#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[ ! -d "${ROOT:-.}/docs" ] || test -f "${ROOT:-.}/docs/operations/phase15.2-channel-commerce-e2e.md"
cd "$ROOT"

required=(
  "spec/releases/phase-15.2-channel-commerce-e2e.yaml"
  "scripts/integration/phase15.2-e2e-preflight.sh"
  "scripts/integration/phase15.2-scenario-template.sh"
  "scripts/integration/phase15.2-validate-evidence.sh"
)

for file in "${required[@]}"; do
  test -f "$file" || { echo "FAIL missing: $file"; exit 1; }
done

for file in \
  scripts/integration/phase15.2-e2e-preflight.sh \
  scripts/integration/phase15.2-scenario-template.sh \
  scripts/integration/phase15.2-validate-evidence.sh
do
  test -x "$file" || { echo "FAIL not executable: $file"; exit 1; }
done

grep -q 'wf10_is_authorization_boundary' spec/releases/phase-15.2-channel-commerce-e2e.yaml
grep -q 'wf20_is_privileged_commerce_boundary' spec/releases/phase-15.2-channel-commerce-e2e.yaml
grep -q 'unknown_outcome: reconcile_before_retry' spec/releases/phase-15.2-channel-commerce-e2e.yaml
grep -q 'live_channel_e2e: NOT_EXECUTED' spec/releases/phase-15.2-channel-commerce-e2e.yaml

echo "PASS: Phase 15.2 E2E contract checks"
echo "NOTE: live channel/commerce E2E remains NOT EXECUTED."
