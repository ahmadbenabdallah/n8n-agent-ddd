import { spawnSync } from "node:child_process";
const command = process.argv[2] ?? "doctor";
const scripts: Record<string,string> = {doctor:"scripts/doctor.ts",validate:"scripts/validate.ts",test:"scripts/test.ts",plan:"scripts/validate.ts",security:"scripts/validate.ts"};
const script=scripts[command];
if(!script){console.error(`Unknown harness command: ${command}`);process.exit(1)}
const r=spawnSync("pnpm",["exec","tsx",script],{stdio:"inherit",shell:process.platform==="win32"});
process.exit(r.status??1);
