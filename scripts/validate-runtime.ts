import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";

const required = [
  "runtime/n8n/runtime.yaml",
  "runtime/supabase/runtime.yaml",
  "runtime/redis/runtime.yaml",
  "runtime/reverse-proxy/runtime.yaml",
  "contracts/platform/workflow.yaml",
  "spec/schemas/workflow.schema.json",
  "infrastructure/deployment/release.yaml",
  "domains/tunisia-dtc/workflows/WF-10/workflow.yaml",
  "domains/tunisia-dtc/workflows/WF-20/workflow.yaml",
  "domains/tunisia-dtc/workflows/WF-16/workflow.yaml"
];

let failed = false;
for (const file of required) {
  if (existsSync(join(process.cwd(), file))) console.log(`✓ ${file}`);
  else {
    console.error(`✗ missing runtime artifact: ${file}`);
    failed = true;
  }
}

const wf10 = readFileSync(join(process.cwd(), "domains/tunisia-dtc/workflows/WF-10/workflow.yaml"), "utf8");
for (const rule of [
  "llm_can_authorize: false",
  "only_authorized_branch_can_set_execution_allowed: true"
]) {
  if (!wf10.includes(rule)) {
    console.error(`✗ WF-10 invariant missing: ${rule}`);
    failed = true;
  }
}

const wf20 = readFileSync(join(process.cwd(), "domains/tunisia-dtc/workflows/WF-20/workflow.yaml"), "utf8");
for (const rule of [
  "callable_by_llm: false",
  "callable_without_wf10_authorization: false",
  "arbitrary_endpoint: false",
  "client_supplied_price: false"
]) {
  if (!wf20.includes(rule)) {
    console.error(`✗ WF-20 invariant missing: ${rule}`);
    failed = true;
  }
}

const wf16 = readFileSync(join(process.cwd(), "domains/tunisia-dtc/workflows/WF-16/workflow.yaml"), "utf8");
if (!wf16.includes("No unverified price, stock, order or payment claims")) {
  console.error("✗ WF-16 invariant missing: renderer reports verified facts only");
  failed = true;
}

process.exit(failed ? 1 : 0);
