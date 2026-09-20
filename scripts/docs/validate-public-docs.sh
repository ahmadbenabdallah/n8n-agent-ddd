#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PUBLIC="$ROOT/documentation"

[[ -d "$PUBLIC" ]] || { echo "missing public documentation directory" >&2; exit 1; }

# Public docs must have title + summary frontmatter once migrated to ReadMe.
# The current engine snapshot may contain legacy category/order frontmatter; this
# validator therefore checks for obvious secret material and internal path leaks.
if grep -RniE '(^|[^A-Z])(api[_-]?key|secret|password|private[_ -]?key|token)\s*[:=]' "$PUBLIC" --include='*.md' >/dev/null 2>&1; then
  echo "possible secret-like material found in public documentation" >&2
  exit 1
fi

if grep -RniE 'docs/(architecture|security|operations|agents)/' "$PUBLIC" --include='*.md' >/dev/null 2>&1; then
  echo "internal docs path leaked into public documentation" >&2
  exit 1
fi

echo "public documentation boundary: OK"
