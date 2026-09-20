#!/usr/bin/env bash
# The shared workflow library must stay consistent and domain-agnostic, and
# every `from_library` reference in a domain registry must resolve.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

LIB=platform/workflows/library.yaml
test -f "$LIB"
test -f platform/workflows/README.md

mapfile -t entries < <(sed -n 's/^  - id:[[:space:]]*\(\S\+\).*/\1/p' "$LIB")
if [[ "${#entries[@]}" -eq 0 ]]; then
  echo "FAIL: $LIB declares no entries" >&2
  exit 1
fi

# Every entry's workflow file must exist and be valid JSON with nodes.
mapfile -t paths < <(sed -n 's/^    path:[[:space:]]*\(\S\+\).*/\1/p' "$LIB")
if [[ "${#paths[@]}" -ne "${#entries[@]}" ]]; then
  echo "FAIL: $LIB has ${#entries[@]} entries but ${#paths[@]} paths" >&2
  exit 1
fi
for p in "${paths[@]}"; do
  f="platform/workflows/$p"
  if [[ ! -f "$f" ]]; then
    echo "FAIL: library entry points at missing file $f" >&2
    exit 1
  fi
  node -e "
    const wf = JSON.parse(require('fs').readFileSync('$f','utf8'));
    if (!Array.isArray(wf.nodes) || wf.nodes.length === 0) {
      console.error('FAIL: $f has no nodes'); process.exit(1);
    }
  "
done

# The library names no domain. A domain id here would make the platform depend
# on the reference example.
for d in domains/*/; do
  [[ -d "$d" ]] || continue
  domain="$(basename "$d")"
  if grep -rqi "$domain" platform/workflows/*/workflow.json platform/workflows/channels/*/workflow.json 2>/dev/null; then
    echo "FAIL: a library workflow names the domain '$domain'" >&2
    exit 1
  fi
done

# Entries declared domain_agnostic must not reference another workflow by id.
node -e '
const fs = require("fs"), path = require("path");
const lib = fs.readFileSync("platform/workflows/library.yaml", "utf8");
const blocks = lib.split(/^  - id: /m).slice(1);
let failed = false;
for (const block of blocks) {
  const id = block.split(/\s/)[0];
  const agnostic = /^\s+domain_agnostic:\s*true\s*$/m.test(block);
  const binds = /^\s+requires_binding:\s*\n\s+- /m.test(block);
  const p = block.match(/^\s+path:\s*(\S+)/m)?.[1];
  if (!p) { console.error(`FAIL: entry ${id} has no path`); failed = true; continue; }
  const wf = fs.readFileSync(path.join("platform/workflows", p), "utf8");
  // A workflow that calls others must declare requires_binding.
  const ids = [...new Set([...wf.matchAll(/WF-\d{2}/g)].map((m) => m[0]))];
  const callsOthers = ids.length > 1;
  if (callsOthers && !binds) {
    console.error(`FAIL: ${id} references ${ids.join(",")} but declares no requires_binding`);
    failed = true;
  }
  if (agnostic && !binds && callsOthers) {
    console.error(`FAIL: ${id} claims domain_agnostic with unbound references`);
    failed = true;
  }
}
process.exit(failed ? 1 : 0);
'

# Every from_library reference in a domain registry must resolve to an entry.
refs=0
for registry in domains/*/workflows/registry.yaml; do
  [[ -f "$registry" ]] || continue
  domain_dir="${registry%/workflows/registry.yaml}"
  domain="${domain_dir##*/}"
  while IFS= read -r ref; do
    [[ -n "$ref" ]] || continue
    if ! printf '%s\n' "${entries[@]}" | grep -qx "$ref"; then
      echo "FAIL: $domain references unknown library entry '$ref'" >&2
      exit 1
    fi
    refs=$((refs + 1))
  done < <(sed -n 's/^[[:space:]]*from_library:[[:space:]]*\(\S\+\).*/\1/p' "$registry")
done

echo "SHARED WORKFLOW LIBRARY PASS (${#entries[@]} entries, $refs domain references)"
