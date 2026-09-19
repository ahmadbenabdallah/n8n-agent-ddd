#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[ ! -d "${ROOT:-.}/docs" ] || test -f "${ROOT:-.}/docs/operations/phase15.8-drift-self-healing.md"

for f in   spec/releases/phase-15.8-drift-self-healing-execution.yaml   scripts/operations/phase15.8-preflight.sh   scripts/operations/phase15.8-inject-drift.sh   scripts/operations/phase15.8-run-control-loop.sh   scripts/operations/phase15.8-validate-safety.sh   scripts/operations/phase15.8-validate-evidence.sh
do
  test -f "$ROOT/$f"
done

for f in   scripts/operations/phase15.8-preflight.sh   scripts/operations/phase15.8-inject-drift.sh   scripts/operations/phase15.8-run-control-loop.sh   scripts/operations/phase15.8-validate-safety.sh   scripts/operations/phase15.8-validate-evidence.sh
do
  bash -n "$ROOT/$f"
done

grep -q 'production_execution: false' "$ROOT/spec/releases/phase-15.8-drift-self-healing-execution.yaml"
grep -q 'autonomous_business_authorization: false' "$ROOT/spec/releases/phase-15.8-drift-self-healing-execution.yaml"
grep -q 'human_ownership_blocks_conflicting_automation: true' "$ROOT/spec/releases/phase-15.8-drift-self-healing-execution.yaml"
grep -q 'observe_before_act: true' "$ROOT/spec/releases/phase-15.8-drift-self-healing-execution.yaml"
grep -q 'verify_after_action: true' "$ROOT/spec/releases/phase-15.8-drift-self-healing-execution.yaml"
grep -q 'DRIFT:' "$ROOT/spec/releases/phase-15.8-drift-self-healing-execution.yaml"
grep -q 'SELF_HEAL:' "$ROOT/spec/releases/phase-15.8-drift-self-healing-execution.yaml"
grep -q 'SAFETY:' "$ROOT/spec/releases/phase-15.8-drift-self-healing-execution.yaml"
grep -q 'AUDIT:' "$ROOT/spec/releases/phase-15.8-drift-self-healing-execution.yaml"
grep -q 'status: "NOT_EXECUTED"' "$ROOT/spec/releases/phase-15.8-drift-self-healing-execution.yaml"

echo "Phase 15.8 contract: PASS"
echo "Repository contract only; no live drift/self-healing evidence is claimed."
