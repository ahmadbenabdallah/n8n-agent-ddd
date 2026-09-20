#!/usr/bin/env bash
set -euo pipefail

: "${EVIDENCE_DIR:=runtime/evidence/phase-15.1}"
mkdir -p "$EVIDENCE_DIR"

python3 - "$EVIDENCE_DIR/execution-matrix.json" <<'PY'
import json, sys
keys = [f"WF-{i:02d}" for i in range(21)]
matrix = []
for key in keys:
    matrix.append({
        "workflow_key": key,
        "inventory": "NOT_EXECUTED",
        "smoke": "NOT_EXECUTED",
        "error_path": "NOT_EXECUTED",
        "audit_path": "NOT_EXECUTED"
    })
json.dump({"status":"NOT_EXECUTED","workflows":matrix}, open(sys.argv[1],"w",encoding="utf-8"), indent=2)
PY

echo "NOT_EXECUTED: execution matrix initialized; live execution not performed."
