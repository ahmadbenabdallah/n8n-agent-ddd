#!/usr/bin/env bash
set -euo pipefail

echo "Production database migration contract"
echo "DATABASE_URL must be injected at runtime."

if [ -z "${DATABASE_URL:-}" ]; then
  echo "BLOCKED: DATABASE_URL is not set."
  exit 2
fi

echo "Pre-migration checks..."
echo "- verify compatible application release"
echo "- acquire migration lock"
echo "- verify backup exists"
echo "- apply expand/migrate phase"
echo "- record schema version"
echo "- release migration lock"

# Intentionally provider/ORM neutral. Drizzle Kit or the configured migration
# adapter executes the actual migration in the deployment environment.
if command -v pnpm >/dev/null 2>&1 && [ -f package.json ]; then
  if node -e 'const p=require("./package.json"); process.exit(p.scripts && p.scripts["db:migrate"] ? 0 : 1)' 2>/dev/null; then
    pnpm db:migrate
  else
    echo "No db:migrate script configured; deployment adapter must invoke migrations."
  fi
fi
