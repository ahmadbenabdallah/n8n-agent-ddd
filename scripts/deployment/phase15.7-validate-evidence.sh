#!/usr/bin/env bash
set -euo pipefail
EVIDENCE_DIR="${EVIDENCE_DIR:-runtime/evidence/phase-15.7}"
for item in blue-baseline green-deploy traffic-switch rollback verification; do
  [[ -e "$EVIDENCE_DIR/$item" ]] || echo "MISSING evidence category: $item"
done
echo "Structural evidence validation only."
echo "BG/ROLLBACK/MIGRATION_COMPATIBILITY remain NOT_EXECUTED until live evidence exists."
