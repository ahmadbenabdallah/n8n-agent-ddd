#!/usr/bin/env bash
set -euo pipefail
root="domains/tunisia-dtc/workflows"
mapfile -t dirs < <(find "$root" -mindepth 1 -maxdepth 1 -type d | sort)
[[ "${#dirs[@]}" -eq 21 ]] || { echo "Expected 21 workflow directories, found ${#dirs[@]}" >&2; exit 1; }
mkdir -p runtime/state
{
  echo "domain_id= tunisia-dtc"
  for d in "${dirs[@]}"; do basename "$d"; done
} > runtime/state/workflow-sync-plan.txt
echo "21 workflow sync plan generated"
