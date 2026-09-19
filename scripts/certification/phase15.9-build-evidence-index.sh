#!/usr/bin/env bash
set -euo pipefail
OUT="${OUT:-runtime/evidence/phase-15.9/evidence-index.yaml}"
mkdir -p "$(dirname "$OUT")"
cat > "$OUT" <<'EOF'
certification_evidence:
  phase: "0.15.9"
  environment: "staging"
  gates:
    INT: NOT_EXECUTED
    WF21: NOT_EXECUTED
    E2E: NOT_EXECUTED
    SECURITY: NOT_EXECUTED
    IDEMP: NOT_EXECUTED
    RECON: NOT_EXECUTED
    LOAD: NOT_EXECUTED
    DR: NOT_EXECUTED
    BG: NOT_EXECUTED
    ROLLBACK: NOT_EXECUTED
    DRIFT: NOT_EXECUTED
    SELF_HEAL: NOT_EXECUTED
    SAFETY: NOT_EXECUTED
    AUDIT: NOT_EXECUTED
EOF
echo "Evidence index created: $OUT"
