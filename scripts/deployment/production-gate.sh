#!/usr/bin/env bash
set -euo pipefail
MANIFEST="${1:?usage: production-gate.sh <manifest.json>}"
python3 - "$MANIFEST" <<'PY'
import json,sys
m=json.load(open(sys.argv[1]))
if m.get("signature",{}).get("status") != "verified":
    raise SystemExit("BLOCKED: release signature is not verified")
print("PASS: release signature verified")
PY
echo "Production signature gate passed."
