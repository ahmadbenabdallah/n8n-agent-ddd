#!/usr/bin/env bash
set -euo pipefail

test -f spec/releases/phase-12-autonomous-operations.yaml
test -f spec/architecture/operations-control-loop.yaml
test -f spec/architecture/observability-contract.yaml
test -f spec/architecture/workflow-drift.yaml
test -f spec/architecture/reconciliation.yaml
test -f platform/observability/health.ts
test -f platform/observability/reconciliation.ts
test -f platform/observability/drift.ts
test -f platform/observability/self-healing.ts
test -f platform/observability/cost.ts

grep -q "never_blind_retry_unknown_external_outcomes" spec/releases/phase-12-autonomous-operations.yaml
grep -q "operational_automation_is_not_business_authorization" spec/releases/phase-12-autonomous-operations.yaml
grep -q "source_of_truth: git" spec/architecture/workflow-drift.yaml
echo "PASS: Phase 12 operations architecture"
