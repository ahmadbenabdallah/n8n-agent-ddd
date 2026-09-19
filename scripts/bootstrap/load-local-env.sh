#!/usr/bin/env bash
set -euo pipefail
file="${1:-.env.local}"
test -f "$file" || { echo "Missing $file. Run generate-local-env.sh." >&2; exit 1; }
set -a
source "$file"
set +a
echo "Local runtime environment loaded."
