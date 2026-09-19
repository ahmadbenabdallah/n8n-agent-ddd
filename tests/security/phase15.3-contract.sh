#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[ ! -d "${ROOT:-.}/docs" ] || test -f "${ROOT:-.}/docs/security/phase15.3-red-team.md"
cd "$ROOT"

required=(
  "spec/releases/phase-15.3-security-red-team.yaml"
  "scripts/security/phase15.3-red-team-preflight.sh"
  "scripts/security/phase15.3-matrix.sh"
  "scripts/security/phase15.3-validate.sh"
)

for file in "${required[@]}"; do
  test -f "$file" || { echo "FAIL missing: $file"; exit 1; }
done

for file in \
  scripts/security/phase15.3-red-team-preflight.sh \
  scripts/security/phase15.3-matrix.sh \
  scripts/security/phase15.3-validate.sh
do
  test -x "$file" || { echo "FAIL not executable: $file"; exit 1; }
done

grep -q 'LLM_cannot_set_execution_allowed' spec/releases/phase-15.3-security-red-team.yaml
grep -q 'MCP_is_not_commerce_authorization' spec/releases/phase-15.3-security-red-team.yaml
grep -q 'credentials_never_enter_llm_context' spec/releases/phase-15.3-security-red-team.yaml
grep -q 'live_red_team: NOT_EXECUTED' spec/releases/phase-15.3-security-red-team.yaml

echo "PASS: Phase 15.3 security/red-team contract checks"
echo "NOTE: live adversarial execution remains NOT EXECUTED."
