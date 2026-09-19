#!/usr/bin/env bash
set -euo pipefail

: "${CONFIRM_MIGRATION:?Set CONFIRM_MIGRATION=YES to execute migrations}"

if [[ "$CONFIRM_MIGRATION" != "YES" ]]; then
  echo "ERROR: migration blocked"
  exit 1
fi

command -v pnpm >/dev/null 2>&1 || {
  echo "ERROR: pnpm is required"
  exit 1
}

pnpm drizzle-kit migrate
echo "Migration command completed. Run verification before traffic."
