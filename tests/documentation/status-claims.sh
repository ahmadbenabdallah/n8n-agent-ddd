#!/usr/bin/env bash
# Status-claim contract for the four shipped status documents (NAD-008.1).
#
# A CONTENT check, not a presence check: three documents once shipped three
# different placeholder counts while every presence check passed.
#
# A missing target is a FAILURE, never a skip. The `[ ! -d "$ROOT/docs" ] ||`
# idiom used elsewhere in this suite silently no-ops in a clean clone and is
# deliberately not used here.
#
# Every pattern below is exercised against an embedded corpus (the self-test in
# section 5) holding the real pre-NAD-008.1 sentences and the mutations that
# survived the first version of this guard. A pattern tuned to a sentence that
# no longer exists therefore fails the self-test instead of passing silently.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

self="tests/documentation/status-claims.sh"
targets=(README.md ARCHITECTURE.md ROADMAP.md documentation/getting-started/index.md)
canonical="21 of the reference domain's runtime workflows are placeholders; four real graphs exist in the shared library"

fail() {
  echo "FAIL documentation/status-claims: $*"
  exit 1
}

# Forbidden claims. "any" patterns apply to every shipped document; "count"
# patterns only to the four status documents, where a workflow count means
# something. Over-matching is intended: a false positive here is loud and cheap
# to fix, a false negative is how three contradictory counts shipped.
#
# The boundary is enforced in platform/authorization/port.ts and the inbound
# signature in platform/channels/meta-signature.ts, both behaviourally tested.
# A document saying otherwise is stale, however it phrases it.
patterns=(
  "any@@(boundary|handshake|authorization port|execution gate)[^.]{0,80}(\bnot\b|n't|\bnever\b|\bun)[a-z ]{0,20}(enforce|implement)"
  "any@@enforce[a-z]* only"
  "any@@(nothing|nobody|no code|no component) enforces[^.]{0,60}(boundar|authoriz|execution|signature)"
  "any@@(is|are|remains|stays) unenforced"
  "any@@signatur[a-z-]*[^.]{0,40}\b(are|is)[^.]{0,6}(\bnot\b|n't|\bun)[a-z ]{0,16}(verif|check|implement)"
  "any@@(skip|ignor)[a-z]*[^.]{0,30}(signature|verification)"
  "any@@signatur[a-z-]*[^.]{0,40}(is|are) (ignored|skipped|bypassed|optional)"
  "count@@[0-9]+ ?(of|out of|/) ?(the )?[0-9]+[a-z'’ -]{0,40}workflow"
  "count@@[0-9]+ ?(of|out of|/) ?(the )?21\b"
  "count@@(two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty)[a-z-]* of (the )?(twenty|[0-9]+)[a-z'’ -]{0,40}workflow"
  "count@@workflows?( [a-z'’-]+){0,3} (are|is) (now )?(implemented|real|active|functional|complete|executable|working|live|genuine)"
  "count@@\bnot all\b[^.]{0,40}(21|workflow)"
)

# pattern_args <scope|all> - fills PAT_ARGS with grep -e arguments.
pattern_args() {
  local scope="$1" entry
  PAT_ARGS=()
  for entry in "${patterns[@]}"; do
    if [ "$scope" != all ]; then
      case "$entry" in "$scope@@"*) ;; *) continue ;; esac
    fi
    PAT_ARGS+=(-e "${entry#*@@}")
  done
}

# scan <scope|all> <file...> - returns 0 when something hit, and then prints
# the hits attributed to the pattern that caught them.
#
# One grep for all patterns on the hot path (the shipped-document sweep is
# ~1300 files), re-run per pattern only to explain a failure. No xargs, so a
# path containing a space cannot turn a real error into a silent pass: grep
# status 0 = found, 1 = clean, anything else aborts the test.
scan() {
  local scope="$1" entry pattern out status
  shift
  pattern_args "$scope"
  if out="$(grep -nEi "${PAT_ARGS[@]}" -- "$@")"; then status=0; else status=$?; fi
  case "$status" in
    1) return 1 ;;
    0) ;;
    *) fail "grep exited $status scanning ${#PAT_ARGS[@]} claim patterns" ;;
  esac
  for entry in "${patterns[@]}"; do
    if [ "$scope" != all ]; then
      case "$entry" in "$scope@@"*) ;; *) continue ;; esac
    fi
    pattern="${entry#*@@}"
    if out="$(grep -nEi -e "$pattern" -- "$@")"; then
      printf '  matched /%s/\n%s\n' "$pattern" "$out"
    fi
  done
  return 0
}

# flagged_lines <scope|all> <file> - line numbers any pattern hit.
flagged_lines() {
  pattern_args "$1"
  grep -nEi "${PAT_ARGS[@]}" -- "$2" | cut -d: -f1 | sort -un || true
}

# bad_counts <file...> - every number that qualifies "workflow(s)" and is not
# the number of workflow files on disk. WF-NN ids are not counts, so a digit
# preceded by '-' or by an alphanumeric is skipped.
bad_counts() {
  grep -hoEi "(^|[^-[:alnum:]])[0-9]+( [a-z'’-]+){0,5} workflows?\b" "$@" |
    grep -oE '[0-9]+' | sort -u | grep -vx "$on_disk" || true
}

# --- 1. the canonical sentence, verbatim, in every target --------------------
for f in "${targets[@]}"; do
  [ -f "$f" ] || fail "missing status document: $f"
  grep -qF "$canonical" "$f" || fail "$f does not carry the canonical sentence verbatim: \"all $canonical\""
done

# --- 2. the count matches the files on disk, and no target states another ----
on_disk="$(find runtime/n8n/workflows -maxdepth 1 -name '*.json' | wc -l | tr -d '[:space:]')"
[ "$on_disk" = 21 ] || fail "runtime/n8n/workflows holds $on_disk workflows, the documents claim 21"

# One-line floor on "placeholder"; the per-artifact contract is NAD-008.2.
inactive="$(grep -l -- '"active": false' runtime/n8n/workflows/*.json | wc -l | tr -d '[:space:]' || true)"
[ "$inactive" = "$on_disk" ] || fail "only $inactive of $on_disk runtime workflows declare \"active\": false, so \"placeholders\" is stale"

offenders="$(bad_counts "${targets[@]}")"
[ -z "$offenders" ] || fail "contradicting workflow count(s) $(echo "$offenders" | tr '\n' ' ')in the status documents (on disk: $on_disk)"

if scan count "${targets[@]}"; then
  fail "a status document splits or flips the workflow count (above); all $on_disk are placeholders"
fi

# --- 3. no shipped document may claim a gap that has since closed -----------
# Scans tracked markdown and YAML. .ai-sdlc is local lifecycle tooling, not a
# shipped document; this file is excluded by path because it quotes the
# forbidden phrasings on purpose. domains/ IS scanned: reference-domain specs
# describe fail-closed behaviour ("a webhook whose signature cannot be verified
# is rejected"), which the patterns are shaped not to flag.
shipped=()
while IFS= read -r -d '' f; do shipped+=("$f"); done < <(
  git ls-files -z -- '*.md' '*.yaml' '*.yml' ':!.ai-sdlc' ":!$self"
)
[ "${#shipped[@]}" -gt 100 ] || fail "found only ${#shipped[@]} shipped documents to scan, expected the whole tree"

if scan any "${shipped[@]}"; then
  fail "a shipped document claims an enforced boundary or signature check is missing (above)"
fi

# --- 4. the claims the prose rests on, asserted -----------------------------
# AC #1: the leading blockquote and the Project status table must agree, so
# both are pinned. A target-wide grep is not enough - README states the count
# three times, and the blockquote may not be the one that drops it.
grep -E '^> \*\*Status:' README.md | grep -qF "$canonical" ||
  fail "README.md's leading status blockquote must carry the canonical sentence"

grep -qE "^\| Authorization boundary \| Enforced in platform code" README.md ||
  fail "README.md's Project status table must still say the boundary is enforced in platform code"

if grep -nE "^- \[x\].*(WF-10 deny-by-default|WF-20 execution boundary|WF-16 verified response|execution boundary|verified response boundary|imported and activated|graphs call the)" ROADMAP.md; then
  fail "ROADMAP.md ticks a runtime capability that does not run (above)"
fi

[ "$(grep -cE '^## Phase 8( |$)' ROADMAP.md)" = 1 ] || fail "ROADMAP.md must have exactly one '## Phase 8' section"
head -n 1 ROADMAP.md | grep -qx '# Roadmap' || fail "ROADMAP.md must open with the '# Roadmap' heading, no preamble above it"

# --- 5. self-test: the patterns must catch what they were written for -------
stale="$(mktemp)"
accurate="$(mktemp)"
one="$(mktemp)"
trap 'rm -f "$stale" "$accurate" "$one"' EXIT

# Real pre-NAD-008.1 sentences, and mutations that survived version 1.
cat > "$stale" <<'STALE'
the authorization and execution boundary is not enforced yet
17 of the 21 workflows are stubs, the WF-10 to WF-20 authorization handshake is not enforced
inbound webhook signatures are not verified
4 of the 21 workflows are real n8n workflows (WF-00, WF-01, WF-02, WF-04); the rest are placeholders
the WF-10 to WF-20 authorization handshake is specified but not enforced
the authorization boundary isn't enforced
the authorization boundary has not been enforced
the authorization boundary is not actually enforced
the authorization boundary is enforced only on paper
the authorization boundary is not yet enforced
the authorization handshake is specified but unenforced
the execution gate is not implemented
Nothing enforces the authorization boundary
inbound webhook signatures are unverified
inbound webhook signatures aren't verified
inbound webhook signatures are not checked
webhook signature verification is not implemented
the X-Hub-Signature-256 header is ignored
signatures are verified in tests only; the gateway skips verification
All 21 runtime workflows are implemented and active in production
Not all 21 of the reference domain's runtime workflows are placeholders
20 of the reference domain's runtime workflows are real n8n graphs
all 17 of the reference domain's runtime workflows are placeholders
17 of 21 workflows are stubs
17/21 workflows are stubs
17 Workflows are stubs
seventeen of the twenty-one workflows are stubs
4 of the 21 are real
STALE

# True sentences the patterns must leave alone.
cat > "$accurate" <<'ACCURATE'
All 21 of the reference domain's runtime workflows are placeholders; four real graphs exist in the shared library (platform/workflows/).
The authorization and execution boundary is enforced in platform code, but no n8n graph calls it.
Enforced in platform code (platform/authorization/port.ts, behaviourally tested); not yet wired into the n8n graphs
inbound webhook signatures are verified before normalisation (HMAC-SHA256 over the raw body, constant-time)
A webhook whose signature cannot be verified is rejected.
fails if the gateway accepts a webhook whose signature did not verify
Purpose: fail closed when the signature is missing.
Which component may call the authorization port or the execution gate is not checked and is not checkable there.
A placeholder is a valid n8n workflow of three or four Code nodes that passes data through.
- [x] 21 importable workflow artifacts for the reference domain (placeholders: three or four Code nodes, no trigger, inactive)
ACCURATE

hits=" $(flagged_lines all "$stale" | tr '\n' ' ') "
total="$(grep -c '' "$stale")"
i=1
while [ "$i" -le "$total" ]; do
  case "$hits" in
    *" $i "*) ;;
    *)
      sed -n "${i}p" "$stale" > "$one"
      [ -n "$(bad_counts "$one")" ] ||
        fail "self-test: no pattern catches the stale claim \"$(cat "$one")\""
      ;;
  esac
  i=$((i + 1))
done

if scan all "$accurate"; then
  fail "self-test: a pattern false-positives on an accurate sentence (above)"
fi
[ -z "$(bad_counts "$accurate")" ] || fail "self-test: the count extractor false-positives on an accurate sentence"

echo "PASS: documentation status claims agree across ${#targets[@]} documents"
echo "      ${#shipped[@]} shipped documents scanned, ${#patterns[@]} claim patterns self-tested against $total stale and $(grep -c '' "$accurate") accurate sentences"
