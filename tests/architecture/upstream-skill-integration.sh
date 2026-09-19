#!/usr/bin/env bash
set -euo pipefail

test -f .agents/skills/registry.json
test -f .agents/skills/upstream/n8n/README.md
test -f .agents/skills/upstream/supabase/README.md

grep -q 'n8n-io/skills' .agents/skills/registry.json
grep -q 'supabase/agent-skills' .agents/skills/registry.json
grep -q '"license_review_required": true' .agents/skills/registry.json
grep -q '"version_pin_required": true' .agents/skills/registry.json

echo "PASS: upstream skill integration registry"
