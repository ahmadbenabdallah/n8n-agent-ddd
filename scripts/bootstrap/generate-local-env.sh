#!/usr/bin/env bash
set -euo pipefail
target="${1:-.env.local}"
if [[ -e "$target" ]]; then
  echo "$target already exists; refusing to overwrite." >&2
  exit 1
fi
cp infrastructure/environments/local/.env.example "$target"
chmod 600 "$target"
echo "Created $target. Replace local placeholder secrets before starting n8n."
