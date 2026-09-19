#!/usr/bin/env bash
set -euo pipefail
FILE="${1:?usage: verify-manifest.sh <manifest.json>}"
python3 - "$FILE" <<'PY'
import json,sys
m=json.load(open(sys.argv[1]))
for a,b in [("release","version"),("release","git_commit"),("runtime","orchestrator"),("database","migration_strategy")]:
    if not m.get(a,{}).get(b): raise SystemExit(f"missing release field: {a}.{b}")
print("PASS: release manifest structure")
if m.get("signature",{}).get("status") != "verified":
    print("NOTICE: signature not verified; production must reject this manifest.")
PY
