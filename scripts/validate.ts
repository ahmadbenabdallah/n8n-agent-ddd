import { spawnSync } from "node:child_process";

const commands = [
  ["agents", "scripts/validate-agents.ts"],
  ["skills", "scripts/validate-skills.ts"],
  ["platform", "scripts/validate-platform.ts"],
  ["runtime", "scripts/validate-runtime.ts"]
];

let failed = false;

for (const [name, script] of commands) {
  console.log(`\n== ${name} ==`);
  const result = spawnSync("pnpm", ["exec", "tsx", script], {
    stdio: "inherit",
    shell: process.platform === "win32"
  });
  if ((result.status ?? 1) !== 0) failed = true;
}

console.log(failed ? "\nVALIDATION FAILED" : "\nVALIDATION PASSED");
process.exit(failed ? 1 : 0);
