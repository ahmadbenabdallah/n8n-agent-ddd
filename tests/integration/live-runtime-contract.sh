#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[ ! -d "${ROOT:-.}/docs" ] || test -f "${ROOT:-.}/docs/operations/phase15-live-runtime.md"
cd "$ROOT"

required=(
  "spec/releases/phase-15.0-live-runtime-integration.yaml"
  "scripts/integration/live-runtime-preflight.sh"
  "scripts/integration/validate-evidence.sh"
  "scripts/integration/create-evidence-template.sh"
)

for file in "${required[@]}"; do
  test -f "$file" || { echo "FAIL missing: $file"; exit 1; }
done

for file in \
  scripts/integration/live-runtime-preflight.sh \
  scripts/integration/validate-evidence.sh \
  scripts/integration/create-evidence-template.sh
do
  test -x "$file" || { echo "FAIL not executable: $file"; exit 1; }
done

grep -q 'runtime_reachable: NOT_EXECUTED' spec/releases/phase-15.0-live-runtime-integration.yaml
grep -q 'production_certification: forbidden' spec/releases/phase-15.0-live-runtime-integration.yaml
[ ! -d "${ROOT:-.}/docs" ] || grep -q 'NOT_EXECUTED' docs/operations/phase15-live-runtime.md

echo "PASS: Phase 15.0 live-runtime contract checks"
echo "NOTE: no live runtime PASS is claimed by this release."
