#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SPEC="$ROOT/spec/releases/phase-15.9-final-production-certification.yaml"
test -f "$SPEC"
grep -q 'no_fabricated_evidence: true' "$SPEC"
grep -q 'no_implicit_pass: true' "$SPEC"
grep -q 'production_switch_requires_explicit_approval: true' "$SPEC"
for gate in INT WF21 E2E SECURITY IDEMP RECON LOAD DR BG ROLLBACK DRIFT SELF_HEAL SAFETY AUDIT; do
  grep -q "^  $gate:" "$SPEC" || { echo "Missing gate: $gate"; exit 3; }
done
echo "Phase 15.9 certification contract: PASS"
echo "No production certification is asserted."
