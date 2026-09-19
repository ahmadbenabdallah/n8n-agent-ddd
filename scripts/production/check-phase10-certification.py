#!/usr/bin/env python3
import glob, json, os, sys

roots = sorted(glob.glob("artifacts/phase-10/*/gate-summary.json"))
if not roots:
    print("BLOCKED: no Phase 10 gate summary found")
    sys.exit(2)

with open(roots[-1]) as f:
    data = json.load(f)

if data.get("external_blocked", 0) != 0:
    print("BLOCKED: Phase 10 external staging gates remain unexecuted")
    sys.exit(2)

if data.get("local_fail", 0) != 0:
    print("BLOCKED: Phase 10 local failures exist")
    sys.exit(2)

print("Phase 10 gate summary contains no blocked external gates.")
print("Additional certification/evidence validation is still required before production promotion.")
