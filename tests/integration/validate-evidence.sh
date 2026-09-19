#!/usr/bin/env bash
set -euo pipefail
dir="artifacts/runtime-evidence"
test -d "$dir"
found=0
for f in "$dir"/*.jsonl; do
  [[ -f "$f" ]] || continue
  found=1
  grep -q '"gate":"INT"' "$f"
  grep -q '"gate":"RT"' "$f"
done
[[ "$found" -eq 1 ]]
echo "RUNTIME EVIDENCE FORMAT PASS"
