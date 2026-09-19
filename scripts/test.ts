import { spawnSync } from "node:child_process";
import { existsSync, readdirSync } from "node:fs";
import { join } from "node:path";

// Live checks need a running runtime (N8N_BASE_URL, captured evidence); they are not contract tests.
const LIVE = new Set([
  "tests/integration/preflight.sh",
  "tests/integration/run-preflight.sh",
  "tests/integration/validate-evidence.sh",
]);

const GIT_BASH = "C:\\Program Files\\Git\\bin\\bash.exe";
const bash = process.platform === "win32" && existsSync(GIT_BASH) ? GIT_BASH : "bash"; // avoid WSL bash on Windows

const tsx = (file: string) => spawnSync(process.execPath, ["--import", "tsx", file], { stdio: "inherit" });

const files = readdirSync("tests", { recursive: true, encoding: "utf8" })
  .map((f) => join("tests", f).replaceAll("\\", "/"))
  .filter((f) => /\.(ts|sh)$/.test(f))
  .sort();

let failed = 0;
let passed = 0;
let skipped = 0;

console.log("== validate ==");
if ((tsx("scripts/validate.ts").status ?? 1) !== 0) failed++;

for (const file of files) {
  if (LIVE.has(file)) {
    console.log(`SKIP ${file} (live runtime check)`);
    skipped++;
    continue;
  }
  const result = file.endsWith(".ts") ? tsx(file) : spawnSync(bash, [file], { stdio: "inherit" });
  const ok = (result.status ?? 1) === 0;
  console.log(`${ok ? "PASS" : "FAIL"} ${file}`);
  ok ? passed++ : failed++;
}

if (!existsSync("docs")) console.log("\nnote: internal docs/ absent; docs checks inside contract tests were skipped");
console.log(`\n${passed} passed, ${failed} failed, ${skipped} skipped`);
process.exit(failed ? 1 : 0);
