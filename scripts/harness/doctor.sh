#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fail=0
check_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "MISSING: $1"; fail=1; }; }
check_cmd git
check_cmd bash
check_cmd node
check_cmd pnpm
check_cmd docker
test -f "$ROOT/spec/harness/installer-contract.yaml" || { echo "MISSING: installer contract"; fail=1; }
test -f "$ROOT/spec/harness/configuration-contract.yaml" || { echo "MISSING: configuration contract"; fail=1; }
test -f "$ROOT/spec/runtime/secrets-contract.yaml" || { echo "MISSING: secrets contract"; fail=1; }
if [[ "$fail" -eq 0 ]]; then echo "Doctor checks successful."; else echo "Doctor found prerequisites or contract gaps."; exit 1; fi
