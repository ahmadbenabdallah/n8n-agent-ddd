import { existsSync, readFileSync } from "node:fs";

const required = [
  "SUPABASE_URL",
  "SUPABASE_SERVICE_ROLE_KEY",
  "WOOCOMMERCE_BASE_URL",
  "WOOCOMMERCE_CONSUMER_KEY",
  "WOOCOMMERCE_CONSUMER_SECRET",
  "META_PAGE_ID",
  "META_APP_SECRET",
  "META_VERIFY_TOKEN",
  "META_PAGE_ACCESS_TOKEN",
  "OPENAI_API_KEY",
  "OPENAI_MODEL",
];

const forbiddenValues = ["__INJECT_AT_RUNTIME__", "__PINNED_AT_DEPLOYMENT__"];

let failed = false;
for (const name of required) {
  const value = process.env[name];
  if (!value || forbiddenValues.includes(value)) {
    console.error(`MISSING_RUNTIME_SECRET_OR_CONFIG=${name}`);
    failed = true;
  }
}

const repo = process.cwd();
const requiredFiles = [
  "domains/tunisia-dtc/specs/phase-9.yaml",
  "contracts/external/woocommerce-staging.yaml",
  "contracts/external/meta-messenger-staging.yaml",
  "contracts/external/llm-staging.yaml",
  "tests/integration/phase-9-matrix.yaml",
  "tests/e2e/phase-9-scenarios.yaml",
];

for (const file of requiredFiles) {
  if (!existsSync(`${repo}/${file}`)) {
    console.error(`MISSING_PHASE9_ARTIFACT=${file}`);
    failed = true;
  }
}

if (failed) {
  process.exit(1);
}

console.log("Phase 9 preflight: PASS");
