#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[ ! -d "${ROOT:-.}/docs" ] || test -f "${ROOT:-.}/docs/operations/phase15.9-production-certification.md"
for f in   spec/releases/phase-15.9-final-production-certification.yaml   scripts/certification/phase15.9-preflight.sh   scripts/certification/phase15.9-build-evidence-index.sh   scripts/certification/phase15.9-evaluate.sh   scripts/certification/phase15.9-validate.sh
do test -f "$ROOT/$f"; done
for f in scripts/certification/*.sh; do bash -n "$ROOT/$f"; done
bash "$ROOT/scripts/certification/phase15.9-validate.sh"
echo "Phase 15.9 contract: PASS"
