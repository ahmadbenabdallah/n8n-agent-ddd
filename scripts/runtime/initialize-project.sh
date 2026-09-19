#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/n8n-api.sh"
: "${N8N_PROJECT_NAME:=Tunisia DTC}"
mkdir -p runtime/state
curl -fsS "$N8N_BASE_URL/healthz/readiness" >/dev/null
projects="$(n8n_api GET /projects)"
project_id="$(printf '%s' "$projects" | python3 -c 'import json,sys; d=json.load(sys.stdin); name=sys.argv[1]; xs=d.get("data",d); print(next((x.get("id","") for x in xs if x.get("name")==name),""))' "$N8N_PROJECT_NAME")"
if [[ -z "$project_id" ]]; then
  echo "No existing project named '$N8N_PROJECT_NAME'."
  echo "Project creation requires the n8n account/API capability available to the deployment."
  echo "Use the n8n native UI once for bootstrap, then persist the resulting project ID."
  exit 3
fi
printf '%s
' "$project_id" > runtime/state/n8n-project-id
echo "N8N PROJECT READY: $project_id"
