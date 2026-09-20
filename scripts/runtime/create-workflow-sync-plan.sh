#!/usr/bin/env bash
# Build the n8n desired-state sync plan from every domain's workflow registry.
#
# Usage:
#   create-workflow-sync-plan.sh [OUT]       # all domains
#   DOMAIN_ID=<domain> create-workflow-sync-plan.sh [OUT]
#
# The registry is the source of truth for which workflows exist, so ids are
# whatever the domain declares. Nothing here assumes a domain name, a `WF-NN`
# id shape, or a workflow count.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT="${1:-$ROOT/dist/n8n-workflow-sync-plan.json}"
mkdir -p "$(dirname "$OUT")"

ROOT="$ROOT" OUT="$OUT" DOMAIN_ID="${DOMAIN_ID:-}" node - <<'JS'
const { readFileSync, readdirSync, writeFileSync, existsSync, statSync } = require("node:fs");
const { join, relative } = require("node:path");

const root = process.env.ROOT;
const out = process.env.OUT;
const only = process.env.DOMAIN_ID || "";

const domainsDir = join(root, "domains");
if (!existsSync(domainsDir)) {
  console.error(`No domains directory at ${domainsDir}`);
  process.exit(1);
}

const domains = readdirSync(domainsDir)
  .filter((d) => existsSync(join(domainsDir, d, "workflows", "registry.yaml")))
  .filter((d) => (only ? d === only : true))
  .sort();

if (domains.length === 0) {
  console.error(
    only
      ? `Domain '${only}' has no workflows/registry.yaml under domains/`
      : "No domain has a workflows/registry.yaml under domains/",
  );
  process.exit(1);
}

const posix = (p) => p.split("\\").join("/");

const workflows = [];
for (const domain of domains) {
  const workflowsDir = join(domainsDir, domain, "workflows");
  const registry = readFileSync(join(workflowsDir, "registry.yaml"), "utf8");

  // Ids as the domain-pack contract writes them: `- id: <ID>` entries.
  const ids = [...registry.matchAll(/^\s*-\s*id:\s*([^\s#]+)/gm)].map((m) => m[1]);
  if (ids.length === 0) {
    console.error(`${domain}: registry.yaml declares no workflow ids`);
    process.exit(1);
  }

  for (const id of ids.sort()) {
    const dir = join(workflowsDir, id);
    if (!existsSync(dir) || !statSync(dir).isDirectory()) {
      console.error(`${domain}: registry declares ${id} but ${posix(relative(root, dir))} is missing`);
      process.exit(1);
    }
    workflows.push({
      canonical_key: `${domain}/${id}`,
      domain_id: domain,
      workflow_key: id,
      source_path: posix(relative(root, dir)),
      action: "DISCOVER_THEN_CREATE_OR_UPDATE",
      validate_before_publish: true,
      verify_after_write: true,
      activation: "RELEASE_POLICY",
    });
  }
}

const plan = {
  version: "0.12.8",
  interface: "n8n-instance-mcp",
  desired_state: "git",
  runtime: "n8n",
  domains,
  workflows,
};

writeFileSync(out, JSON.stringify(plan, null, 2) + "\n");
console.log(`${out} (${domains.length} domain(s), ${workflows.length} workflows)`);
JS
