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
#
# Two known ceilings, both accepted rather than bugs to rediscover:
#
#   1. A sentence asserting X and not-X survives - "The boundary is fully
#      enforced in the graphs, though no n8n graph calls it directly" carries
#      the required limit and contradicts it in the same breath. grep cannot
#      resolve that, and the only grep-shaped defence is pinning more literal
#      prose, which makes ordinary copy-editing fail the gate.
#   2. "Twenty-one workflows are production ready" survives: the extractor
#      reads digits, and the spelled-out form escapes it unless it also uses
#      the fractional framing the status patterns cover.
#
# A third limit is a design choice, not a ceiling: patterns are narrow on
# purpose. An earlier revision preferred over-matching and flagged 13 of 20
# honest sentences, including "the boundary is enforced only in platform code,
# not yet in the graphs" - the exact hedge these documents need to be able to
# make. A guard that rejects the most accurate available description of the
# system teaches people to route around it, which is worse than the drift it
# prevents. Those sentences are now in the accurate corpus, so narrowing a
# pattern later is a corpus edit with a test behind it.
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

# Forbidden claims. "any" patterns apply to every shipped document; "status"
# patterns only to the four status documents, where a workflow count or a
# claim about where enforcement happens means something - the last one would
# hit eight lines of correct reference-domain design prose under domains/
# ("Checkout freshness is enforced by WF-14") if it were applied tree-wide.
# Each pattern is as narrow as its corpus line allows, and the liveness check
# in section 5 fails the test if one stops earning its place.
#
# The boundary is enforced in platform/authorization/port.ts and the inbound
# signature in platform/channels/meta-signature.ts, both behaviourally tested.
# A document saying otherwise is stale, however it phrases it.
patterns=(
  "any@@(boundary|handshake|authorization port|execution gate)[^.]{0,80}(\bnot\b|n't|\bnever\b|\bun)[a-z ]{0,20}(enforce|implement)"
  "any@@(nothing|nobody|no code|no component) enforces[^.]{0,60}(boundar|authoriz|execution|signature)"
  "any@@signatur[a-z-]*[^.]{0,40}\b(are|is|was|were|has|have|had)[^.]{0,20}(\bnot\b|n't|\bnever\b|\bun)[a-z ]{0,16}(verif|check|implement)"
  "any@@(does|do|will|would|can|could|shall) ?not (yet )?(verify|check|validate)[^.]{0,30}signatur"
  "any@@cannot[^.]{0,20}(verif|enforce)[^.]{0,30}\b(yet|currently|today|still)\b"
  "any@@(skip|ignor)[a-z]*[^.]{0,30}(signature|verification)"
  "any@@signatur[a-z-]*[^.]{0,40}(is|are) (ignored|skipped|bypassed|optional)"
  "any@@(boundary|handshake|authorization port|execution gate|signature (verification|checking|check))[^.]{0,30}\b(is|are|remains|stays)\b[^.]{0,20}(absent|missing|unimplemented|aspirational|todo|planned|notional|theoretical)"
  "any@@only (in|on) (specification|spec|paper)\b"
  "any@@specified only"
  "status@@[0-9]+ ?(of|out of|/) ?(the )?[0-9]+[a-z'’ -]{0,40}workflow"
  "status@@[0-9]+ ?(of|out of|/) ?(the )?21\b"
  "status@@(two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty)[a-z-]* of (the )?(twenty|[0-9]+)[a-z'’ -]{0,40}workflow"
  "status@@workflows?( [a-z'’-]+){0,3} (are|is) (now )?(implemented|real|active)"
  "status@@\bnot all\b[^.]{0,40}(21|workflow)"
  "status@@(enforced|verified|validated|implemented) (in|by|within|inside) (the |every |all |its |each )?(n8n )?(graphs?|workflows?|WF-[0-9])"
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

if scan status "${targets[@]}"; then
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
# Every pattern above forbids an UNDERSTATEMENT. Nothing in them would stop a
# document from dropping the limiting half and reading "the authorization and
# execution boundary is enforced in platform code." full stop - which is the
# more dangerous direction: an understating document makes a contributor add a
# redundant check, an overstating one invites a deployment of a boundary that
# holds nowhere the platform code does not run. So the limit is pinned as
# required text, one canonical clause in all four documents, exactly as the
# count is. The object varies with the subject (calls it / calls them), so the
# pinned string stops at the verb.
#
# The clause has to sit in the SAME sentence as the enforcement claim. A
# file-wide grep is satisfied by text no reader sees (`<!-- no n8n graph calls
# it -->`) or by the clause parked in an unrelated sentence while the
# enforcement sentence loses its limit, so each document pins the pair.
limit="no n8n graph calls"
# `([^.|]|\.[^ ])*` is "anything up to the end of the sentence": a period
# followed by a space ends it, a period inside `port.ts` does not. Without
# that, parking the clause in a trailing sentence ("... are placeholders.
# Separately, no n8n graph calls the deployment scripts") satisfies the pin
# while the enforcement sentence itself reads as unlimited.
limit_pins=(
  "README.md@@enforced in platform code([^.|]|\.[^ ])*$limit"
  "ARCHITECTURE.md@@enforced in platform code([^.|]|\.[^ ])*$limit"
  "documentation/getting-started/index.md@@enforced in platform code([^.|]|\.[^ ])*$limit"
  "ROADMAP.md@@in place, but $limit"
)
for entry in "${limit_pins[@]}"; do
  f="${entry%%@@*}"
  if ! grep -qE -- "${entry#*@@}" "$f"; then
    fail "$f must state the enforcement claim and its limit in one sentence (/${entry#*@@}/), or the boundary claim reads as unlimited"
  fi
done

if grep -nE -- "<!--[^>]*$limit" "${targets[@]}"; then
  fail "the canonical limiting clause is parked in an HTML comment, where no reader sees it (above)"
fi

# AC #1: the leading blockquote and the Project status table must agree, so
# both halves of both are pinned. A target-wide grep is not enough - README
# states the count three times and the limit twice, and the blockquote may not
# be the copy that drops one.
blockquote="$(grep -E '^> \*\*Status:' README.md || true)"
[ -n "$blockquote" ] || fail "README.md has no leading status blockquote"
printf '%s\n' "$blockquote" | grep -qF "$canonical" ||
  fail "README.md's leading status blockquote must carry the canonical sentence"
printf '%s\n' "$blockquote" | grep -qF "$limit" ||
  fail "README.md's leading status blockquote must carry the canonical limiting clause \"$limit it\""

grep -qE "^\| Authorization boundary \| Enforced in platform code.*not yet wired into the n8n graphs \|$" README.md ||
  fail "README.md's Project status row must say both halves: enforced in platform code, not yet wired into the n8n graphs"

if grep -nE "^- \[x\].*(WF-10 deny-by-default|WF-20 execution boundary|WF-16 verified response|execution boundary|verified response boundary|imported and activated|graphs call the)" ROADMAP.md; then
  fail "ROADMAP.md ticks a runtime capability that does not run (above)"
fi

[ "$(grep -cE '^## Phase 8( |$)' ROADMAP.md)" = 1 ] || fail "ROADMAP.md must have exactly one '## Phase 8' section"
head -n 1 ROADMAP.md | grep -qx '# Roadmap' || fail "ROADMAP.md must open with the '# Roadmap' heading, no preamble above it"

# --- 5. self-test: the patterns must catch what they were written for -------
stale="$(mktemp)"
accurate="$(mktemp)"
domain_only="$(mktemp)"
one="$(mktemp)"
trap 'rm -f "$stale" "$accurate" "$domain_only" "$one"' EXIT

# The corpus is a RATCHET: it only ever grows. It holds the real
# pre-NAD-008.1 sentences, every mutation that survived an earlier version of
# this guard, AND every sentence an earlier version caught - the last group is
# the one that matters. Version 2 rewrote the signature pattern and silently
# dropped `never` from the negation set, so "signatures are never verified",
# which version 1 caught, walked through versions 2 and 3 unnoticed. A
# sentence absent from this corpus is a regression waiting to happen, so a
# hardening round that narrows coverage now fails here instead of shipping.
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
The authorization boundary is absent.
The authorization boundary is missing.
The execution boundary remains aspirational.
Webhook signature verification is planned.
Signature checking is TODO.
The boundary exists only in specification.
The authorization handshake exists only on paper.
The boundary is specified only, never built.
Inbound webhook signatures are never verified.
Inbound webhook signatures are still not verified.
The gateway does not verify signatures.
Webhook signature verification has not been implemented.
The gateway cannot verify signatures yet.
The authorization boundary cannot be enforced yet.
The boundary is fully enforced in the graphs, though no n8n graph calls it directly.
The authorization boundary is enforced in the n8n workflows.
The authorization boundary is unenforced.
17 of the 21 are real workflows
17 of the runtime workflows are stubs.
19 workflows are implemented.
Only 4 real workflows exist.
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
- Credentials live only in n8n credentials/environment secret storage.
Critical business state must not live only in n8n execution history.
Identity, Payment, Knowledge and Observability ports are planned.
- Webhook signature verification is implemented and unit-tested, but like everything else here it has never run against Meta's own requests. The n8n-level check (forged header to the live stack, expect 403) is still unexecuted.
Webhook signature verification | Implemented (HMAC-SHA256 over the raw body, verified before normalisation; not yet exercised against Meta)
The boundary is enforced only in platform code, not yet in the graphs.
The authorization decision exists only in TypeScript today; no graph calls it.
Authorization records live only in Postgres; nothing is cached.
Rate limiting is enforced only on the inbound channel.
Workflow contracts are complete for the reference domain.
ACCURATE

# Scope-dependent: correct where the reference domain designs its own graphs,
# forbidden in the four platform status documents. Asserted both ways, so the
# scope boundary itself is testable rather than a comment.
cat > "$domain_only" <<'DOMAIN'
- [ ] Checkout freshness is enforced by WF-14.
The exact Store API session mechanism is implemented in WF-20, not in WF-12.
Those facts must already be verified by WF-11/WF-12/WF-13/WF-14/WF-15/WF-20.
DOMAIN

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

# The dual of the ratchet: the corpus proves no stale claim is uncovered, this
# proves no pattern is decoration. A pattern that catches nothing is either
# dead (its target is already covered by a broader pattern, so it only adds
# false-positive surface) or misspelt, and both are invisible without this.
# Consequence, deliberately: a new pattern must earn a corpus line.
for entry in "${patterns[@]}"; do
  grep -qEi -e "${entry#*@@}" "$stale" ||
    fail "self-test: pattern /${entry#*@@}/ catches nothing in the stale corpus - delete it or add the sentence it is for"
done

if scan all "$accurate"; then
  fail "self-test: a pattern false-positives on an accurate sentence (above)"
fi
[ -z "$(bad_counts "$accurate")" ] || fail "self-test: the count extractor false-positives on an accurate sentence"

if scan any "$domain_only"; then
  fail "self-test: a tree-wide pattern false-positives on correct reference-domain prose (above)"
fi
scan status "$domain_only" > /dev/null ||
  fail "self-test: the status-scoped patterns no longer catch 'enforced by WF-NN' framing in a status document"

echo "PASS: documentation status claims agree across ${#targets[@]} documents"
echo "      ${#shipped[@]} shipped documents scanned, ${#patterns[@]} claim patterns self-tested against $total stale, $(grep -c "" "$accurate") accurate and $(grep -c "" "$domain_only") scope-dependent sentences"
