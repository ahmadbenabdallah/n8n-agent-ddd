#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[ ! -d "${ROOT:-.}/docs" ] || test -f "${ROOT:-.}/docs/operations/phase15.1-21-workflows.md"
cd "$ROOT"

required=(
  "spec/releases/phase-15.1-21-workflow-execution.yaml"
  "scripts/integration/phase15.1-workflow-inventory.sh"
  "scripts/integration/phase15.1-protected-set.sh"
  "scripts/integration/phase15.1-execution-matrix.sh"
  "scripts/integration/phase15.1-summary.sh"
)

for file in "${required[@]}"; do
  test -f "$file" || { echo "FAIL missing: $file"; exit 1; }
done

for file in \
  scripts/integration/phase15.1-workflow-inventory.sh \
  scripts/integration/phase15.1-protected-set.sh \
  scripts/integration/phase15.1-execution-matrix.sh \
  scripts/integration/phase15.1-summary.sh
do
  test -x "$file" || { echo "FAIL not executable: $file"; exit 1; }
done

grep -q 'expected_count: 21' spec/releases/phase-15.1-21-workflow-execution.yaml
grep -q 'WF-10_before_WF-20: required' spec/releases/phase-15.1-21-workflow-execution.yaml
grep -q 'direct_WF-20_from_LLM: forbidden' spec/releases/phase-15.1-21-workflow-execution.yaml
grep -q 'live_workflow_execution: NOT_EXECUTED' spec/releases/phase-15.1-21-workflow-execution.yaml

echo "PASS: Phase 15.1 workflow execution contract checks"
echo "NOTE: live 21-workflow execution remains NOT EXECUTED."
