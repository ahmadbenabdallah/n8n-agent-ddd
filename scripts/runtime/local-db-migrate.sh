#!/usr/bin/env bash
set -euo pipefail

if command -v pnpm >/dev/null 2>&1; then
  pnpm db:migrate 2>/dev/null || {
    echo "ERROR: database migration command failed or is not defined."
    exit 1
  }
else
  echo "ERROR: pnpm is required for database migrations."
  exit 1
fi
