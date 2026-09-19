#!/usr/bin/env bash
set -euo pipefail

node -e '
const p=require("./package.json");
for (const k of ["drizzle-orm","pg"]) {
  if (!p.dependencies || !p.dependencies[k]) {
    console.error("Missing dependency:", k);
    process.exit(1);
  }
}
if (!p.devDependencies || !p.devDependencies["drizzle-kit"]) {
  console.error("Missing devDependency: drizzle-kit");
  process.exit(1);
}
'
test -f drizzle.config.ts
test -f platform/state/db/schema/core.ts
test -f platform/state/db/migrations/0000_phase11_drizzle_baseline.sql
echo "PASS: Drizzle preflight"
