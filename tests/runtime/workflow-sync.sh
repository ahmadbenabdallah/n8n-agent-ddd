#!/usr/bin/env bash
# Every domain's workflow directories must match its own registry.
# The count is whatever that domain declares; the platform does not care.
set -euo pipefail

test -x scripts/runtime/create-workflow-sync-plan.sh

# Actually generate a plan. Checking only that the file exists hid a broken
# python3 dependency in this script for as long as nothing ran it.
plan="$(mktemp)"
trap 'rm -f "$plan"' EXIT
scripts/runtime/create-workflow-sync-plan.sh "$plan" >/dev/null

domains=0
for registry in domains/*/workflows/registry.yaml; do
  [[ -f "$registry" ]] || continue
  domain_dir="${registry%/workflows/registry.yaml}"
  domain="${domain_dir##*/}"
  workflows_dir="$domain_dir/workflows"

  # Registry ids, in the `- id: <ID>` form the domain-pack contract requires.
  mapfile -t declared < <(sed -n 's/^[[:space:]]*-[[:space:]]*id:[[:space:]]*\([^[:space:]#]\+\).*/\1/p' "$registry" | sort)
  mapfile -t present < <(find "$workflows_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)

  if [[ "${#declared[@]}" -eq 0 ]]; then
    echo "FAIL: $domain declares no workflows in $registry" >&2
    exit 1
  fi

  missing_dir="$(comm -23 <(printf '%s\n' "${declared[@]}") <(printf '%s\n' "${present[@]}"))"
  if [[ -n "$missing_dir" ]]; then
    echo "FAIL: $domain declares workflows with no directory under $workflows_dir:" >&2
    printf '  %s\n' $missing_dir >&2
    exit 1
  fi

  unregistered="$(comm -13 <(printf '%s\n' "${declared[@]}") <(printf '%s\n' "${present[@]}"))"
  if [[ -n "$unregistered" ]]; then
    echo "FAIL: $domain has workflow directories missing from $registry:" >&2
    printf '  %s\n' $unregistered >&2
    exit 1
  fi

  for id in "${declared[@]}"; do
    if ! grep -q "\"canonical_key\": \"$domain/$id\"" "$plan"; then
      echo "FAIL: sync plan has no entry for $domain/$id" >&2
      exit 1
    fi
  done

  echo "  $domain: ${#declared[@]} workflows, registry, directories and plan agree"
  domains=$((domains + 1))
done

if [[ "$domains" -eq 0 ]]; then
  echo "FAIL: no domain registry found under domains/*/workflows/registry.yaml" >&2
  exit 1
fi

echo "WORKFLOW SYNC REGISTRY PARITY PASS ($domains domain(s))"
