import { existsSync, readdirSync, readFileSync } from "node:fs";

const dir = "runtime/n8n/workflows";
const expected = Array.from({length: 21}, (_, i) => `WF-${String(i).padStart(2, "0")}.json`);
const actual = existsSync(dir) ? readdirSync(dir) : [];
const missing = expected.filter(x => !actual.includes(x));
const invalid: string[] = [];

for (const file of expected) {
  const path = `${dir}/${file}`;
  if (!existsSync(path)) continue;
  try {
    JSON.parse(readFileSync(path, "utf8"));
  } catch {
    invalid.push(file);
  }
}

if (missing.length || invalid.length) {
  console.error(JSON.stringify({status:"FAIL", missing, invalid}, null, 2));
  process.exit(1);
}
console.log(JSON.stringify({status:"PASS", workflows:21}, null, 2));
