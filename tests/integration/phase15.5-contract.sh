#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

required=(
  "spec/releases/phase-15.5-load-resilience.yaml"
  "docs/operations/phase15.5-load-resilience.md"
  "scripts/integration/phase15.5-preflight.sh"
  "scripts/integration/phase15.5-profile.sh"
  "scripts/integration/phase15.5-resilience-matrix.sh"
  "scripts/integration/phase15.5-validate.sh"
)

for file in "${required[@]}"; do
  test -f "$file" || { echo "FAIL missing: $file"; exit 1; }
done

for file in \
  scripts/integration/phase15.5-preflight.sh \
  scripts/integration/phase15.5-profile.sh \
  scripts/integration/phase15.5-resilience-matrix.sh \
  scripts/integration/phase15.5-validate.sh
do
  test -x "$file" || { echo "FAIL not executable: $file"; exit 1; }
done

grep -q 'production_load_test: forbidden' spec/releases/phase-15.5-load-resilience.yaml
grep -q 'no_duplicate_business_mutation' spec/releases/phase-15.5-load-resilience.yaml
grep -q 'backpressure_or_rejection' spec/releases/phase-15.5-load-resilience.yaml
grep -q 'live_fault_injection: NOT_EXECUTED' spec/releases/phase-15.5-load-resilience.yaml

echo "PASS: Phase 15.5 load/resilience contract checks"
echo "NOTE: live load/resilience execution remains NOT EXECUTED."
