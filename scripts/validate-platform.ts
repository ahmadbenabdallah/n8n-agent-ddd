import { existsSync, readFileSync } from "node:fs";
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

process.exit(failed ? 1 : 0);
