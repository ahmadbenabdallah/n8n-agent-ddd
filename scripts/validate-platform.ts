import { existsSync, readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";

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

const domain = readFileSync(join(process.cwd(), "domains/tunisia-dtc/domain.yaml"), "utf8");
// WF-16 (renderer) is not a source of truth; its invariant is checked in validate-runtime.ts.
for (const boundary of [
  "authorization: WF-10",
  "privileged_commerce_execution: WF-20",
  "audit: WF-17",
  "monitoring_and_reconciliation: WF-19"
]) {
  if (!domain.includes(boundary)) {
    console.error(`✗ missing domain boundary: ${boundary}`);
    failed = true;
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
