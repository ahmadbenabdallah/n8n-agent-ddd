import { existsSync, readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { readWorkflowRoles, workflowSpecPath } from "./lib/domain-roles";

const required = [
  "runtime/n8n/runtime.yaml",
  "runtime/supabase/runtime.yaml",
  "runtime/redis/runtime.yaml",
  "runtime/reverse-proxy/runtime.yaml",
  "contracts/platform/workflow.yaml",
  "spec/schemas/workflow.schema.json",
  "infrastructure/deployment/release.yaml",
];

let failed = false;
for (const file of required) {
  if (existsSync(join(process.cwd(), file))) console.log(`✓ ${file}`);
  else {
    console.error(`✗ missing runtime artifact: ${file}`);
    failed = true;
  }
}

// Platform invariants are stated per role. Each domain nominates its own
// workflow for a role (see docs ADR 0001), so resolve the role first and then
// check the invariants in whichever workflow contract the domain named.
//
// This is a spec-consistency check, not enforcement: it only confirms that a
// domain's workflow contract still states the invariants it is required to
// state. A substring of a YAML file stops nothing. The authorization boundary
// is enforced in platform/authorization/port.ts and tested behaviourally in
// tests/unit/authorization/boundary.ts; deleting a line below breaks this
// check, and deleting the boundary breaks that one.
const roleInvariants: Record<string, string[]> = {
  authorization: ["llm_can_authorize: false", "only_authorized_branch_can_set_execution_allowed: true"],
  privileged_external_execution: [
    "callable_by_llm: false",
    "callable_without_authorization: false",
    "arbitrary_endpoint: false",
    "client_supplied_price: false",
  ],
  response_rendering: ["No unverified price, stock, order or payment claims"],
};

for (const domain of readdirSync("domains")) {
  const roles = readWorkflowRoles(domain);

  for (const [role, rules] of Object.entries(roleInvariants)) {
    const workflowId = roles[role];
    if (!workflowId) continue; // validate-platform reports missing required roles

    const spec = workflowSpecPath(domain, workflowId);
    if (!existsSync(spec)) continue; // reported by validate-platform
    const contents = readFileSync(spec, "utf8");

    for (const rule of rules) {
      if (!contents.includes(rule)) {
        console.error(`✗ ${domain} ${role} (${workflowId}) invariant missing: ${rule}`);
        failed = true;
      }
    }
  }
}

process.exit(failed ? 1 : 0);
