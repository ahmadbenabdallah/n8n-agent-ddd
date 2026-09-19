#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT="${1:-$ROOT/dist/n8n-workflow-sync-plan.json}"
mkdir -p "$(dirname "$OUT")"

python3 - "$ROOT" "$OUT" <<'PY'
import json,sys
from pathlib import Path
root=Path(sys.argv[1]); out=Path(sys.argv[2])
source=root/"domains/tunisia-dtc/workflows"
items=[]
for p in sorted(source.glob("WF-*")):
    if p.is_dir():
        items.append({
          "canonical_key": f"tunisia-dtc/{p.name}",
          "workflow_key": p.name,
          "source_path": str(p.relative_to(root)),
          "action": "DISCOVER_THEN_CREATE_OR_UPDATE",
          "validate_before_publish": True,
          "verify_after_write": True,
          "activation": "RELEASE_POLICY"
        })
plan={
  "version":"0.12.8",
  "interface":"n8n-instance-mcp",
  "desired_state":"git",
  "runtime":"n8n",
  "workflows":items
}
out.write_text(json.dumps(plan,indent=2)+"\n")
print(out)
PY
