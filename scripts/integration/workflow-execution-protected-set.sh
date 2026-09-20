#!/usr/bin/env bash
set -euo pipefail

: "${EVIDENCE_DIR:=runtime/evidence/phase-15.1}"
mkdir -p "$EVIDENCE_DIR"

cat > "$EVIDENCE_DIR/protected-set.json" <<'EOF'
{
  "status": "NOT_EXECUTED",
  "protected_workflows": ["WF-01", "WF-10", "WF-15", "WF-20"],
  "rule": "Protected workflow mutation and activation are release-gated."
}
EOF

echo "NOT_EXECUTED: protected-set verification requires a configured live n8n runtime."
