#!/usr/bin/env bash
set -euo pipefail

: "${EVIDENCE_DIR:=runtime/evidence/phase-15.1}"
mkdir -p "$EVIDENCE_DIR"

# The protected set is read from each domain's registry, never hardcoded.
protected_json="$(
  for registry in domains/*/workflows/registry.yaml; do
    [[ -f "$registry" ]] || continue
    domain_dir="${registry%/workflows/registry.yaml}"
    domain="${domain_dir##*/}"
    awk -v d="$domain" '/^- id:/{id=$3} /^[[:space:]]+protected:[[:space:]]*true[[:space:]]*$/{printf "\"%s/%s\",", d, id}' "$registry"
  done | sed 's/,$//'
)"

cat > "$EVIDENCE_DIR/protected-set.json" <<EOF
{
  "status": "NOT_EXECUTED",
  "protected_workflows": [$protected_json],
  "rule": "Protected workflow mutation and activation are release-gated."
}
EOF

echo "NOT_EXECUTED: protected-set verification requires a configured live n8n runtime."
