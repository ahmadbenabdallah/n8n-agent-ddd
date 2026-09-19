#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

[[ -f "$ROOT/spec/releases/phase-20.3-readme-bidirectional-sync.yaml" ]]
[ ! -d "${ROOT:-.}/docs" ] || [[ -f "$ROOT/docs/architecture/readme-bidirectional-sync.md" ]]
[ ! -d "${ROOT:-.}/docs" ] || [[ -f "$ROOT/docs/operations/readme-bidirectional-sync.md" ]]
[[ -f "$ROOT/scripts/docs/validate-public-docs.sh" ]]

bash -n "$ROOT/scripts/docs/validate-public-docs.sh"
"$ROOT/scripts/docs/validate-public-docs.sh"

echo "phase 20.3 contract: PASS"
