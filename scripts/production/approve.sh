#!/usr/bin/env bash
set -euo pipefail

RELEASE="${1:?release version required}"
APPROVER="${2:?approver identifier required}"

mkdir -p "artifacts/phase-11/approvals"
cat > "artifacts/phase-11/approvals/${RELEASE}.approval.json" <<EOF
{
  "release": "${RELEASE}",
  "approver": "${APPROVER}",
  "approved": true,
  "note": "Explicit approval recorded. This does not bypass Phase 10 certification."
}
EOF

echo "Approval recorded for $RELEASE by $APPROVER"
