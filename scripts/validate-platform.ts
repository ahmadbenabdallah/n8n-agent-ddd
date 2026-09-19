import { existsSync, readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";
import {
  EXTERNAL_EXECUTION_ROLE,
  REQUIRED_ROLES,
  mutatesExternalSystem,
  readRegistryIds,
  readWorkflowRoles,
  workflowSpecPath
} from "./lib/domain-roles";

const required = [
  "contracts/platform/action.yaml",
  "contracts/platform/identity.yaml",
  "contracts/platform/authorization.yaml",
  "contracts/platform/idempotency.yaml",
  "contracts/platform/domain-state.yaml",
  "contracts/platform/event.yaml",
  "spec/invariants/platform.yaml",
  "domains/tunisia-dtc/workflows/registry.yaml",
  "domains/tunisia-dtc/domain.yaml"
];

let failed = false;

for (const file of required) {
  if (!existsSync(join(process.cwd(), file))) {
    console.error(`✗ missing platform artifact: ${file}`);
    failed = true;
  } else {
    console.log(`✓ ${file}`);
  }
}

const auth = readFileSync(join(process.cwd(), "contracts/platform/authorization.yaml"), "utf8");
for (const rule of [
  "only_wf10_can_authorize_commerce_execution",
  "llm_does_not_authorize",
  "unknown_external_outcome_requires_reconciliation"
]) {
  if (!auth.includes(rule)) {
    console.error(`✗ missing authorization invariant: ${rule}`);
    failed = true;
  }
}

// Each domain nominates its own workflows for the platform roles (ADR 0001).
// The platform checks the mapping exists and resolves; it never names a
// workflow id itself.
for (const domain of readdirSync("domains")) {
  const roles = readWorkflowRoles(domain);
  const registry = readRegistryIds(domain);
  const expected = [...REQUIRED_ROLES, ...(mutatesExternalSystem(domain) ? [EXTERNAL_EXECUTION_ROLE] : [])];

  for (const role of expected) {
    const workflowId = roles[role];
    if (!workflowId) {
      console.error(`✗ ${domain}: workflow_roles is missing '${role}'`);
      failed = true;
      continue;
    }
    if (!registry.includes(workflowId)) {
      console.error(`✗ ${domain}: role '${role}' names ${workflowId}, which is not in the domain registry`);
      failed = true;
    }
    if (!existsSync(workflowSpecPath(domain, workflowId))) {
      console.error(`✗ ${domain}: role '${role}' names ${workflowId}, which has no workflow.yaml`);
      failed = true;
    }
  }
}

// Every domain pack, and the template users copy, must satisfy the domain-pack contract.
const contract = readFileSync(join(process.cwd(), "spec/domains/domain-pack-contract.yaml"), "utf8");
const packRequired = (contract.split(/^\s*required:\s*$/m)[1] ?? "")
  .split("\n")
  .map((line) => line.match(/^\s+-\s+(\S+)\s*$/)?.[1])
  .filter((entry): entry is string => Boolean(entry));
const packs = ["templates/domain-pack", ...readdirSync("domains").map((d) => `domains/${d}`)];
for (const pack of packs) {
  for (const entry of packRequired) {
    if (!existsSync(join(process.cwd(), pack, entry))) {
      console.error(`✗ domain pack ${pack} is missing ${entry}`);
      failed = true;
    }
  }
}
if (packRequired.length === 0) {
  console.error("✗ could not read the required list from spec/domains/domain-pack-contract.yaml");
  failed = true;
}

process.exit(failed ? 1 : 0);
