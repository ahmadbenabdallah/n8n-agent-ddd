#!/usr/bin/env bash
set -euo pipefail

: "${EVIDENCE_DIR:=runtime/evidence/phase-15.2}"
mkdir -p "$EVIDENCE_DIR"

cat > "$EVIDENCE_DIR/scenario-results.json" <<'EOF'
{
  "status": "NOT_EXECUTED",
  "scenarios": [
    {"id":"informational_product_question","status":"NOT_EXECUTED"},
    {"id":"add_to_cart","status":"NOT_EXECUTED"},
    {"id":"checkout","status":"NOT_EXECUTED"},
    {"id":"cod_order","status":"NOT_EXECUTED"},
    {"id":"invalid_authorization","status":"NOT_EXECUTED"},
    {"id":"unknown_external_outcome","status":"NOT_EXECUTED"},
    {"id":"private_order_request_without_scope","status":"NOT_EXECUTED"}
  ]
}
EOF

cat > "$EVIDENCE_DIR/commerce-verification.json" <<'EOF'
{"status":"NOT_EXECUTED","rule":"Commerce provider remains authoritative for live commerce state."}
EOF

cat > "$EVIDENCE_DIR/authorization-evidence.json" <<'EOF'
{"status":"NOT_EXECUTED","rule":"WF-10 is the authorization boundary."}
EOF

cat > "$EVIDENCE_DIR/audit-evidence.json" <<'EOF'
{"status":"NOT_EXECUTED","rule":"WF-17 records audit evidence but does not authorize mutations."}
EOF

cat > "$EVIDENCE_DIR/evidence-summary.json" <<'EOF'
{"status":"NOT_EXECUTED","phase":"15.2","live_channel_e2e":false,"live_commerce_mutations":false}
EOF

echo "Created non-certifying Phase 15.2 evidence templates."
