#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

RUN_ID="${PHASE10_RUN_ID:-gates-$(date -u +%Y%m%dT%H%M%SZ)}"
OUT="artifacts/phase-10/$RUN_ID"
mkdir -p "$OUT"

PASS=0
FAIL=0
BLOCKED=0

gate() {
  local id="$1"
  local mode="$2"
  shift 2

  if [ "$mode" = "local" ]; then
    echo "==> $id [LOCAL]"
    if "$@" >"$OUT/$id.log" 2>&1; then
      echo "PASS" > "$OUT/$id.status"
      echo "PASS $id"
      PASS=$((PASS+1))
    else
      echo "FAIL" > "$OUT/$id.status"
      echo "FAIL $id"
      FAIL=$((FAIL+1))
    fi
  else
    echo "NOT_EXECUTED" > "$OUT/$id.status"
    echo "BLOCKED_EXTERNAL_STAGING" > "$OUT/$id.reason"
    echo "BLOCKED $id (real staging evidence required)"
    BLOCKED=$((BLOCKED+1))
  fi
}

gate INT local bash scripts/readiness/local/run-local.sh
gate ARCH local bash -c '
  test -f spec/releases/phase-10-execution.yaml
  test -f spec/releases/phase-10-execution-split.yaml
  test -f spec/releases/phase-11-production-deployment.yaml
  test -f spec/architecture/production-deployment.yaml
'
gate CONTRACTS local bash -c '
  test -d contracts/platform
  test -d contracts/external
'
gate WORKFLOWS local bash -c '
  test "$(find runtime/n8n/workflows -maxdepth 1 -name "WF-*.json" | wc -l | tr -d " ")" = "21"
'
gate DOMAIN local bash -c '
  test -f domains/tunisia-dtc/domain.yaml
  test -f domains/tunisia-dtc/domain-project.yaml
'
gate SECURITY_REPO local bash scripts/production/preflight.sh

gate SEC staging
gate E2E staging
gate IDEMP staging
gate RECON staging
gate RT staging
gate LOAD staging
gate DR staging
gate BG staging
gate DRIFT staging
gate SECURITY staging

cat > "$OUT/gate-summary.json" <<EOF
{
  "run_id": "$RUN_ID",
  "local_pass": $PASS,
  "local_fail": $FAIL,
  "external_blocked": $BLOCKED,
  "production_certification": "BLOCKED",
  "reason": "Real staging evidence has not been executed.",
  "staging_environment_preserved": true
}
EOF

echo
echo "Gate execution summary:"
echo "  Local PASS: $PASS"
echo "  Local FAIL: $FAIL"
echo "  Staging NOT EXECUTED: $BLOCKED"
echo "  Production certification: BLOCKED"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
