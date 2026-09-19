#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

for f in   spec/releases/phase-17.0-harness-control-plane.yaml   spec/harness/task-lifecycle.yaml   spec/harness/advisor-decision.yaml   spec/harness/command-contract.yaml   spec/harness/mcp-policy.yaml   docs/agents/harness-control-plane.md   scripts/harness/harness.sh   scripts/harness/validate-task-transition.sh   scripts/harness/production-action-gate.sh
do
  test -f "$ROOT/$f"
done

for f in scripts/harness/*.sh; do
  bash -n "$ROOT/$f"
done

grep -q 'harness_is_not_customer_runtime: true' "$ROOT/spec/releases/phase-17.0-harness-control-plane.yaml"
grep -q 'harness_is_not_workflow_editor: true' "$ROOT/spec/releases/phase-17.0-harness-control-plane.yaml"
grep -q 'n8n_native_dashboard_remains_operator_ui: true' "$ROOT/spec/releases/phase-17.0-harness-control-plane.yaml"
grep -q 'capability_discovery_is_not_authorization: true' "$ROOT/spec/releases/phase-17.0-harness-control-plane.yaml"
grep -q 'harness_cannot_bypass_WF-10: true' "$ROOT/spec/releases/phase-17.0-harness-control-plane.yaml"
grep -q 'Critical-risk changes require explicit human approval.' "$ROOT/spec/harness/advisor-decision.yaml"

echo "Phase 17.0 contract: PASS"
echo "Harness control-plane foundation only; no autonomous production execution is claimed."
