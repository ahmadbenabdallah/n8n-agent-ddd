import { existsSync } from "node:fs";

const required = [
  "contracts/external/woocommerce-staging.yaml",
  "contracts/external/meta-messenger-staging.yaml",
  "contracts/external/llm-staging.yaml",
  "tests/integration/phase-9-matrix.yaml",
  "tests/e2e/phase-9-scenarios.yaml",
  "tests/red-team/phase-9-cases.yaml",
  "tests/disaster-recovery/phase-9-plan.yaml",
];

const missing = required.filter((x) => !existsSync(x));
if (missing.length) {
  console.error(JSON.stringify({ status: "FAIL", missing }, null, 2));
  process.exit(1);
}
console.log(JSON.stringify({ status: "PASS", artifacts: required.length }, null, 2));
