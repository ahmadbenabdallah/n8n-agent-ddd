#!/usr/bin/env bash
# Instantiating templates/domain-pack must produce a pack that satisfies the
# platform contract, for both commerce shapes.
#
# F1 found the template still carrying the reference domain's workflow ids a
# whole refactor after the role split, because nothing in the repo ever
# instantiated it. This does, on every test run, so that class of rot fails
# here instead of in an adopter's first copy.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

SCAFFOLD=plugins/domain-builder/scripts/scaffold-domain.mjs
test -f "$SCAFFOLD"

OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

# Required pack entries, read from the contract rather than restated here.
mapfile -t required < <(
  awk '/^  required:/{f=1;next} /^  [a-z_]+:/{f=0} f && /^    - /{print $2}' spec/domains/domain-pack-contract.yaml
)
[[ "${#required[@]}" -gt 0 ]] || fail "could not read the required list from the domain-pack contract"

# role -> the pack's own workflow id (ADR 0001), parsed exactly as
# scripts/lib/domain-roles.ts parses it: a role line ends at the id. A pack
# that leaves the template's trailing comment on the line reads as no mapping
# at all, so a tolerant parser here would pass output the platform rejects.
role_id() {
  awk -v want="$2" '
    /^workflow_roles:/{f=1;next} /^[^ ]/{f=0}
    f && $0 ~ "^[ ]+"want":[ ]*[^ ]+[ ]*$" {print $2; exit}
  ' "$1/domain.yaml"
}

check_pack() {
  local pack="$1" commerce="$2"

  for entry in "${required[@]}"; do
    test -e "$pack/$entry" || fail "$commerce: scaffolded pack is missing $entry"
  done

  # Nothing the scaffold was supposed to fill may survive into the pack.
  if grep -rqE '<(workflow id|ID|your-domain-id|your_domain_id|context-id|AREA|Human-readable name|YYYY)' "$pack"; then
    grep -rnE '<(workflow id|ID|your-domain-id|your_domain_id|context-id|AREA|Human-readable name|YYYY)' "$pack" >&2
    fail "$commerce: unfilled structural placeholder in the scaffolded pack"
  fi

  # The platform names no workflow id, so generated output must not either.
  if grep -rqE '\bWF-[0-9]{2}\b' "$pack"; then
    grep -rnE '\bWF-[0-9]{2}\b' "$pack" >&2
    fail "$commerce: scaffolded pack carries a reference-domain workflow id"
  fi

  # Every required role resolves to an id that is in the registry and on disk.
  local roles=(authorization response_rendering audit reconciliation)
  if [[ "$commerce" != none ]]; then
    roles+=(privileged_external_execution)
  elif [[ -n "$(role_id "$pack" privileged_external_execution)" ]]; then
    fail "none: pack declares privileged_external_execution with no external system of record"
  fi

  local role id
  for role in "${roles[@]}"; do
    id="$(role_id "$pack" "$role")"
    [[ -n "$id" ]] || fail "$commerce: workflow_roles is missing '$role'"
    grep -q "^- id: $id\$" "$pack/workflows/registry.yaml" || fail "$commerce: $role names $id, not in the registry"
    test -f "$pack/workflows/$id/workflow.yaml" || fail "$commerce: $role names $id, which has no workflow.yaml"
    grep -q "^  role: $role\$" "$pack/workflows/$id/workflow.yaml" || fail "$commerce: $id does not declare $role"
  done

  # The invariants validate-runtime.ts looks for, in the workflow each role names.
  grep -q 'llm_can_authorize: false' "$pack/workflows/$(role_id "$pack" authorization)/workflow.yaml" ||
    fail "$commerce: authorization workflow is missing llm_can_authorize"
  grep -q 'only_authorized_branch_can_set_execution_allowed: true' \
    "$pack/workflows/$(role_id "$pack" authorization)/workflow.yaml" ||
    fail "$commerce: authorization workflow is missing only_authorized_branch_can_set_execution_allowed"
  grep -q 'No unverified price, stock, order or payment claims' \
    "$pack/workflows/$(role_id "$pack" response_rendering)/workflow.yaml" ||
    fail "$commerce: response renderer does not forbid unverified claims"
  if [[ "$commerce" != none ]]; then
    local exec_spec="$pack/workflows/$(role_id "$pack" privileged_external_execution)/workflow.yaml"
    for rule in 'callable_by_llm: false' 'callable_without_authorization: false' 'arbitrary_endpoint: false' 'client_supplied_price: false'; do
      grep -q "$rule" "$exec_spec" || fail "$commerce: privileged execution workflow is missing '$rule'"
    done
  fi

  # Registry and workflow directories must agree, as tests/runtime/workflow-sync.sh requires of a live domain.
  diff <(sed -n 's/^-[[:space:]]*id:[[:space:]]*\([^[:space:]#]\+\).*/\1/p' "$pack/workflows/registry.yaml" | sort) \
    <(find "$pack/workflows" -mindepth 1 -maxdepth 1 -type d -not -name '.*' -printf '%f\n' | sort) ||
    fail "$commerce: registry and workflow directories disagree"

  # Every adopted library reference must resolve.
  while IFS= read -r ref; do
    [[ -n "$ref" ]] || continue
    grep -q "^  - id: $ref\$" platform/workflows/library.yaml || fail "$commerce: unknown library entry '$ref'"
  done < <(sed -n 's/^[[:space:]]*from_library:[[:space:]]*\(\S\+\).*/\1/p' "$pack/workflows/registry.yaml")

  echo "  $commerce: ${#required[@]} required entries, ${#roles[@]} roles resolved, registry and directories agree"
}

# commerce: none is the demo-booking shape (four roles); a commerce system adds the fifth.
node "$SCAFFOLD" --repo "$ROOT" --out "$OUT/none" --id scaffold-check --name "Scaffold Check" \
  --prefix SCHK --context operations --commerce none >/dev/null
check_pack "$OUT/none" none

node "$SCAFFOLD" --repo "$ROOT" --out "$OUT/commerce" --id scaffold-check --name "Scaffold Check" \
  --prefix SCHK --context operations --commerce woocommerce >/dev/null
check_pack "$OUT/commerce" woocommerce

# The scaffold must refuse to overwrite silently.
if node "$SCAFFOLD" --repo "$ROOT" --out "$OUT/none" --id scaffold-check --name x --prefix SCHK >/dev/null 2>&1; then
  fail "the scaffold overwrote an existing pack without --force"
fi

echo "DOMAIN SCAFFOLD PASS (template instantiates cleanly for both commerce shapes)"
