#!/usr/bin/env bash
set -euo pipefail

EVIDENCE_DIR="${EVIDENCE_DIR:-runtime/evidence/phase-15.8}"

for item in drift decision action verification audit; do
  [[ -e "$EVIDENCE_DIR/$item" ]] || echo "MISSING evidence category: $item"
done

echo "Structural evidence validation only."
echo "DRIFT/SELF_HEAL/SAFETY/AUDIT remain NOT_EXECUTED until live evidence exists."
