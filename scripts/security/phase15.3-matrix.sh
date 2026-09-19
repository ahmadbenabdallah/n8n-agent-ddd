#!/usr/bin/env bash
set -euo pipefail

: "${EVIDENCE_DIR:=runtime/evidence/phase-15.3}"
mkdir -p "$EVIDENCE_DIR"

python3 - "$EVIDENCE_DIR/red-team-matrix.json" <<'PY'
import json, sys
ids = [f"RT-{i:03d}" for i in range(1, 21)]
json.dump({
    "status": "NOT_EXECUTED",
    "cases": [{"id": x, "status": "NOT_EXECUTED"} for x in ids]
}, open(sys.argv[1], "w", encoding="utf-8"), indent=2)
PY

cat > "$EVIDENCE_DIR/authorization-boundary.json" <<'EOF'
{
  "status": "NOT_EXECUTED",
  "rules": [
    "WF-10 is authorization boundary",
    "WF-20 is privileged commerce boundary",
    "LLM cannot set execution_allowed"
  ]
}
EOF

cat > "$EVIDENCE_DIR/secret-safety.json" <<'EOF'
{
  "status": "NOT_EXECUTED",
  "rule": "No secrets are permitted in LLM context or runtime evidence."
}
EOF

cat > "$EVIDENCE_DIR/data-isolation.json" <<'EOF'
{
  "status": "NOT_EXECUTED",
  "rules": [
    "cross-customer order access denied or escalated",
    "cross-domain access denied"
  ]
}
EOF

echo "Created non-certifying red-team evidence matrix."
