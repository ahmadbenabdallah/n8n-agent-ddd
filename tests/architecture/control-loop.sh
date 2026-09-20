#!/usr/bin/env bash
set -euo pipefail
pnpm exec tsx tests/unit/observability/control-loop.ts
grep -q 'human_owner_active' spec/architecture/autonomous-operations-control.yaml
grep -q 'unknown_commerce_outcome_requires_reconciliation' spec/architecture/autonomous-operations-control.yaml
grep -q 'hard_stop_ratio' spec/architecture/autonomous-operations-control.yaml
test -f spec/schemas/incident.schema.json
test -f spec/schemas/operations-control-decision.schema.json
echo "PASS: Phase 12 control-loop architecture"
