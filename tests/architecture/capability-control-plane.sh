#!/usr/bin/env bash
set -euo pipefail

test -f spec/architecture/capability-control-plane.yaml
test -f spec/architecture/tool-policy.yaml
test -f spec/architecture/mcp-registry.yaml
test -f spec/architecture/plugin-manifest.schema.json
test -f spec/architecture/plugin-registry.yaml
test -f spec/architecture/skill-router.yaml

test -f platform/capabilities/tool-policy.ts
test -f platform/capabilities/skill-router.ts
test -f platform/capabilities/plugin-registry.ts
test -f platform/capabilities/mcp-registry.ts

grep -q 'bypass_wf10' spec/architecture/mcp-registry.yaml
grep -q 'commerce.mutation' spec/architecture/tool-policy.yaml
grep -q 'skill_selection_is_not_permission_grant' spec/architecture/capability-control-plane.yaml

echo "PASS: capability control plane"
