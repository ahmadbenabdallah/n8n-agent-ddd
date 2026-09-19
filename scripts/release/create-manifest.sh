#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
VERSION="${1:-$(node -p "require('$ROOT/package.json').version")}"
OUT="$ROOT/dist/release-manifest-${VERSION}.json"
mkdir -p "$ROOT/dist"
GIT_COMMIT="$(git -C "$ROOT" rev-parse HEAD 2>/dev/null || echo unknown)"
python3 - "$ROOT" "$VERSION" "$GIT_COMMIT" "$OUT" <<'PY'
import json, os, sys, hashlib
root, version, commit, out=sys.argv[1:]
def sha(path):
    h=hashlib.sha256()
    with open(path,"rb") as f:
        for c in iter(lambda:f.read(1024*1024),b""): h.update(c)
    return h.hexdigest()
m={"release":{"version":version,"git_commit":commit},
   "runtime":{"orchestrator":"n8n"},
   "database":{"migration_strategy":"expand-migrate-contract"},
   "workflow_source":{"path":"domains/tunisia-dtc/workflows"},
   "artifacts":{},"signature":{"status":"unsigned","key_id":None}}
for rel in ["package.json","runtime/bootstrap/runtime-manifest.yaml"]:
    p=os.path.join(root,rel)
    if os.path.exists(p): m["artifacts"][rel]=sha(p)
with open(out,"w") as f: json.dump(m,f,indent=2); f.write("\n")
print(out)
PY
