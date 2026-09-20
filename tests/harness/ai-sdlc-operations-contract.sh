#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[ ! -d "${ROOT:-.}/docs" ] || test -f "${ROOT:-.}/docs/agents/autonomous-ai-sdlc-operations.md"
files=(
spec/releases/phase-19.0-autonomous-ai-sdlc-operations.yaml
spec/harness/agent-topology.yaml
spec/harness/task-graph-contract.yaml
spec/harness/session-state-contract.yaml
spec/harness/autonomy-policy.yaml
spec/harness/evaluation-contract.yaml
scripts/harness/agents.sh
scripts/harness/evaluate.sh
)
for f in "${files[@]}"; do test -f "$ROOT/$f" || { echo "MISSING: $f"; exit 1; }; done
for f in scripts/harness/*.sh; do bash -n "$ROOT/$f"; done
grep -q 'customer_runtime_remains_n8n_domain_runtime: true' "$ROOT/spec/releases/phase-19.0-autonomous-ai-sdlc-operations.yaml"
grep -q 'isolated_worktrees: true' "$ROOT/spec/releases/phase-19.0-autonomous-ai-sdlc-operations.yaml"
grep -q 'human_approval_for_high_impact_actions: true' "$ROOT/spec/releases/phase-19.0-autonomous-ai-sdlc-operations.yaml"
grep -q 'live_multi_agent_execution: "NOT_EXECUTED"' "$ROOT/spec/releases/phase-19.0-autonomous-ai-sdlc-operations.yaml"
grep -q 'may_change_authorization_without_review: false' "$ROOT/spec/harness/evaluation-contract.yaml"
echo "Phase 19 contract successful."
