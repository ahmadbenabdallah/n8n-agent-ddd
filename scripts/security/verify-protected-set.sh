#!/usr/bin/env bash
# Every workflow a domain marks `protected: true` must exist, and every
# workflow filling a platform role must be protected. Ids are the domain's
# (ADR 0001); this script names none.
set -euo pipefail

domains=0
for registry in domains/*/workflows/registry.yaml; do
  [[ -f "$registry" ]] || continue
  domain_dir="${registry%/workflows/registry.yaml}"
  domain="${domain_dir##*/}"

  mapfile -t protected < <(awk '/^- id:/{id=$3} /^[[:space:]]+protected:[[:space:]]*true[[:space:]]*$/{print id}' "$registry")
  if [[ "${#protected[@]}" -eq 0 ]]; then
    echo "FAIL: $domain marks no workflow protected in $registry" >&2
    exit 1
  fi

  for wf in "${protected[@]}"; do
    if [[ ! -d "$domain_dir/workflows/$wf" ]]; then
      echo "FAIL: $domain marks $wf protected but $domain_dir/workflows/$wf does not exist" >&2
      exit 1
    fi
  done

  # A workflow that fills a platform role must not be operator-editable.
  mapfile -t role_ids < <(sed -n '/^workflow_roles:/,/^[^[:space:]]/p' "$domain_dir/domain.yaml" \
    | sed -n 's/^[[:space:]]\+[a-z_]\+:[[:space:]]*\([^[:space:]#]\+\).*/\1/p')
  for wf in "${role_ids[@]}"; do
    [[ -n "$wf" ]] || continue
    if ! printf '%s\n' "${protected[@]}" | grep -qx "$wf"; then
      echo "FAIL: $domain fills a platform role with $wf but does not mark it protected" >&2
      exit 1
    fi
  done

  echo "  $domain: ${#protected[@]} protected, ${#role_ids[@]} role workflows all protected"
  domains=$((domains + 1))
done

if [[ "$domains" -eq 0 ]]; then
  echo "FAIL: no domain registry found" >&2
  exit 1
fi

echo "PROTECTED WORKFLOW SET PASS ($domains domain(s))"
