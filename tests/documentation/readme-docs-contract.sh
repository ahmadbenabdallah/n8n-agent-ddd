#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
required=(
  README.md
  CHANGELOG.md
  documentation/README.md
  documentation/getting-started/index.md
  documentation/getting-started/concepts.md
  documentation/installation/index.md
  documentation/configuration/index.md
  documentation/deployment/index.md
  documentation/operations/index.md
  documentation/operations/troubleshooting.md
  documentation/development/index.md
  documentation/development/architecture.md
  documentation/development/domain-development.md
  documentation/development/workflow-development.md
  documentation/development/testing.md
  documentation/development/security.md
  documentation/development/ai-agents.md
  documentation/development/release-process.md
  documentation/development/documentation.md
  documentation/operations/readme-publishing.md
  docs/README.md
  docs/architecture/0.17-0.20-platform-evolution.md
  docs/architecture/documentation-boundary.md
  .github/workflows/readme-docs.yml
)
for f in "${required[@]}"; do
  test -f "$ROOT/$f" || { echo "MISSING: $f"; exit 1; }
done
grep -Fq 'readmeio/rdme@v10' "$ROOT/.github/workflows/readme-docs.yml"
grep -Fq 'README_API_KEY' "$ROOT/.github/workflows/readme-docs.yml"
grep -Fq 'README_VERSION' "$ROOT/.github/workflows/readme-docs.yml"
grep -Fq './documentation' "$ROOT/.github/workflows/readme-docs.yml"
grep -Fq 'docs/' "$ROOT/docs/architecture/documentation-boundary.md"
grep -Fq '0.20 — Multi-Domain Platform' "$ROOT/docs/architecture/0.17-0.20-platform-evolution.md"
grep -Fq 'Internal `docs/` content is not published' "$ROOT/documentation/development/documentation.md"
echo "Documentation boundary contract successful."
