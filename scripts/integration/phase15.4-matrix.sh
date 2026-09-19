#!/usr/bin/env bash
set -euo pipefail

: "${EVIDENCE_DIR:=runtime/evidence/phase-15.4}"
mkdir -p "$EVIDENCE_DIR"

python3 - "$EVIDENCE_DIR/idempotency-matrix.json" "$EVIDENCE_DIR/reconciliation-matrix.json" <<'PY'
import json, sys
ids = [
    "ID-001","ID-002","ID-003","ID-004","ID-005","ID-006",
    "ID-007","ID-008","ID-009","ID-010","ID-011","ID-012"
]
json.dump({
    "status":"NOT_EXECUTED",
    "cases":[{"id":x,"status":"NOT_EXECUTED"} for x in ids]
}, open(sys.argv[1],"w",encoding="utf-8"), indent=2)

recon = [
    "provider_timeout_after_mutation",
    "provider_timeout_before_mutation",
    "reconciliation_success",
    "reconciliation_failure",
    "reconciliation_unknown",
    "payment_unknown_outcome"
]
json.dump({
    "status":"NOT_EXECUTED",
    "cases":[{"id":x,"status":"NOT_EXECUTED"} for x in recon]
}, open(sys.argv[2],"w",encoding="utf-8"), indent=2)
PY

cat > "$EVIDENCE_DIR/mutation-ledger.json" <<'EOF'
{
  "status": "NOT_EXECUTED",
  "state_machine": [
    "REQUESTED",
    "AUTHORIZED",
    "EXECUTION_STARTED",
    "COMMERCE_MUTATION",
    "VERIFICATION",
    "COMPLETED"
  ]
}
EOF

cat > "$EVIDENCE_DIR/restart-persistence.json" <<'EOF'
{
  "status": "NOT_EXECUTED",
  "requirement": "Idempotency records must survive runtime restart."
}
EOF

echo "Created non-certifying Phase 15.4 evidence matrices."
