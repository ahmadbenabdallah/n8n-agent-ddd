#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT"

RUN_ID="${PHASE10_LOCAL_RUN_ID:-local-$(date -u +%Y%m%dT%H%M%SZ)}"
OUT="artifacts/phase-10/$RUN_ID"
mkdir -p "$OUT"

status=0

run_check() {
  local name="$1"
  shift
  echo "==> $name"
  if "$@" >"$OUT/$name.log" 2>&1; then
    echo "PASS $name"
    echo "PASS" > "$OUT/$name.status"
  else
    echo "FAIL $name"
    echo "FAIL" > "$OUT/$name.status"
    status=1
  fi
}

run_check workflows bash -c '
  test "$(find runtime/n8n/workflows -maxdepth 1 -name "WF-*.json" | wc -l | tr -d " ")" = "21"
'

run_check contracts bash -c '
  test -d contracts
  test -d spec/schemas
'

run_check architecture bash -c '
  test -d spec/invariants
'

run_check domain bash -c '
  test -f domains/tunisia-dtc/domain.yaml
  test -f domains/tunisia-dtc/domain-project.yaml
'

run_check agents bash -c '
  test -d .agents/skills
  test -f AGENTS.md
  test -f agent-manifest.yaml
'

run_check phase10-spec bash -c '
  test -f spec/releases/phase-10-execution.yaml
  test -f tests/execution/phase-10-command-map.yaml
'

cat > "$OUT/local-summary.json" <<EOF
{
  "run_id": "$RUN_ID",
  "execution_scope": "local",
  "production_certification": "BLOCKED",
  "staging_required": true,
  "status": "$( [ "$status" -eq 0 ] && echo PASS || echo FAIL )"
}
EOF

echo
echo "Phase 10 local execution complete."
echo "Evidence: $OUT"
echo "Production certification remains BLOCKED until required staging evidence exists."

exit "$status"
