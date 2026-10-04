#!/usr/bin/env bash
# Status-claim contract for the four shipped status documents (NAD-008.1).
#
# This is a CONTENT check, not a presence check. Three documents once shipped
# three different placeholder counts while every presence check passed.
#
# A missing target is a FAILURE, never a skip: the `[ ! -d "$ROOT/docs" ] ||`
# idiom used elsewhere in this suite silently no-ops in a clean clone, and is
# deliberately not used here.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

fail() {
  echo "FAIL documentation/status-claims: $*"
  exit 1
}

targets=(README.md ARCHITECTURE.md ROADMAP.md documentation/getting-started/index.md)

# 1. The canonical count sentence, verbatim, in every target. Scoped to the
#    reference domain every time: the platform has no workflow count.
canonical="21 of the reference domain's runtime workflows are placeholders; four real graphs exist in the shared library"
for f in "${targets[@]}"; do
  [ -f "$f" ] || fail "missing status document: $f"
  grep -qF "$canonical" "$f" || fail "$f does not carry the canonical sentence verbatim: \"all $canonical\""
done

# 2. The count has to match the files on disk, and no target may state another.
on_disk="$(find runtime/n8n/workflows -maxdepth 1 -name '*.json' | wc -l | tr -d '[:space:]')"
[ "$on_disk" = 21 ] || fail "runtime/n8n/workflows holds $on_disk workflows, the documents claim 21"

# WF-NN ids are not counts, so a digit preceded by '-' or an alphanumeric is skipped.
while read -r n; do
  [ -z "$n" ] && continue
  [ "$n" = "$on_disk" ] || fail "contradicting workflow count '$n' in the status documents (on disk: $on_disk)"
done <<< "$(grep -hoE "(^|[^-[:alnum:]])[0-9]+( [a-z]+){0,3} workflows?\b" "${targets[@]}" | grep -oE '[0-9]+' | sort -u)"

# A fractional claim ("17 of the 21 workflows are stubs") contradicts the
# canonical sentence by construction, whichever numbers it uses.
if grep -hnE '[0-9]+ of the ([0-9]+ workflows?|21\b)' "${targets[@]}"; then
  fail "a target splits the workflow count into working/stub halves; all 21 are placeholders"
fi

# 3. No shipped document may claim a gap that has since closed. tests/ is
#    excluded because this file quotes the forbidden phrasings; domains/ is
#    excluded because reference-domain specs describe their own WF contracts.
shipped="$(git ls-files '*.md' | grep -v '^domains/' | grep -v '^tests/')"
[ -n "$shipped" ] || fail "found no shipped markdown to scan"

boundary_claim="(boundary|handshake)[^.]{0,40}(is|are|remains) ?(not|un) ?(yet )?enforced"
signature_claim="signatures?[^.]{0,40}(are|is) (not|never) verified"

# The boundary is enforced in platform/authorization/port.ts, the inbound
# signature in platform/channels/meta-signature.ts. Both are behaviourally
# tested; a document saying otherwise is stale.
for pattern in "$boundary_claim" "$signature_claim"; do
  if echo "$shipped" | xargs grep -nEi "$pattern"; then
    fail "a shipped document claims an enforced boundary or signature check is missing (see above)"
  fi
done

# 4. ROADMAP structure: one Phase 8, nothing before the title.
[ "$(grep -cE '^## Phase 8( |$)' ROADMAP.md)" = 1 ] || fail "ROADMAP.md must have exactly one '## Phase 8' section"
head -n 1 ROADMAP.md | grep -qx '# Roadmap' || fail "ROADMAP.md must open with the '# Roadmap' heading, no preamble above it"

echo "PASS: documentation status claims agree across ${#targets[@]} documents"
