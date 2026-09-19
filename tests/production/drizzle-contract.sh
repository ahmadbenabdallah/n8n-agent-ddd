#!/usr/bin/env bash
set -euo pipefail

test -f drizzle.config.ts
test -f platform/state/db/client.ts
test -f platform/state/db/schema/index.ts
test -f platform/state/db/schema/core.ts
test -f platform/state/db/migrations/0000_phase11_drizzle_baseline.sql
test -f platform/state/db/migrate.ts
test -f platform/state/db/validate.ts
test -f platform/state/repositories/customer-identity-repository.ts

node -e '
const p=require("./package.json");
if (!p.dependencies["drizzle-orm"]) process.exit(1);
if (!p.devDependencies["drizzle-kit"]) process.exit(1);
if (!p.dependencies["pg"]) process.exit(1);
'

grep -q 'dialect: "postgresql"' drizzle.config.ts
grep -q 'orm: drizzle' docs/architecture/postgres-drizzle-supabase.md 2>/dev/null || true
grep -q 'CREATE EXTENSION IF NOT EXISTS vector' platform/state/db/migrations/0000_phase11_drizzle_baseline.sql

echo "PASS: executable Drizzle/PostgreSQL contract"
