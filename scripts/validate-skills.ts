import { existsSync, readdirSync, readFileSync } from "node:fs";
import { join, relative } from "node:path";

const root = join(process.cwd(), ".agents", "skills");
let failed = false;
const names = new Map<string, string>();
let count = 0;

function walk(dir: string) {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const path = join(dir, entry.name);
    if (entry.isDirectory()) walk(path);
    if (!entry.isFile() || entry.name !== "SKILL.md") continue;

    count++;
    const text = readFileSync(path, "utf8");
    const frontmatter = text.match(/^---\s*\n([\s\S]*?)\n---/);
    const name = text.match(/^name:\s*(.+)$/m);
    const description = text.match(/^description:\s*(.+)$/m);

    if (!frontmatter || !name || !description) {
      console.error(`✗ invalid frontmatter: ${relative(process.cwd(), path)}`);
      failed = true;
      continue;
    }

    const skillName = name[1].trim();
    if (!/^[a-z0-9_-]+:[a-z0-9_-]+$/.test(skillName)) {
      console.error(`✗ invalid skill name: ${skillName}`);
      failed = true;
    }

    if (!text.includes("## Required sequence")) {
      console.error(`✗ missing Required sequence: ${skillName}`);
      failed = true;
    }

    if (!text.includes("## Safety")) {
      console.error(`✗ missing Safety section: ${skillName}`);
      failed = true;
    }

    const previous = names.get(skillName);
    if (previous) {
      console.error(`✗ duplicate skill name ${skillName}: ${previous} and ${path}`);
      failed = true;
    }
    names.set(skillName, path);
    console.log(`✓ ${skillName}`);
  }
}

if (!existsSync(root)) {
  console.error("✗ .agents/skills not found");
  process.exit(1);
}

walk(root);
console.log(`Validated ${count} skills.`);
process.exit(failed ? 1 : 0);
