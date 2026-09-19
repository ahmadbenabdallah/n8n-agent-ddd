#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
mkdir -p "$ROOT/runtime/state" "$ROOT/runtime/evidence/phase-18"
touch "$ROOT/runtime/state/.gitkeep"
echo "Harness initialization complete."
