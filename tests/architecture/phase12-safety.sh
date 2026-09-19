#!/usr/bin/env bash
set -euo pipefail

grep -q "bypass_wf10" spec/architecture/mcp-registry.yaml
grep -q "commerce.mutation" spec/architecture/tool-policy.yaml
grep -q "never_duplicate_a_mutation_to_resolve_uncertainty" spec/architecture/reconciliation.yaml
grep -q "self_healing_has_max_attempts" spec/architecture/operations-control-loop.yaml
grep -q "approval_required: true" spec/releases/phase-12-autonomous-operations.yaml
echo "PASS: Phase 12 safety invariants"
