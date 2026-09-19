import {existsSync,readFileSync} from "node:fs"; import {join} from "node:path";
const required=["AGENTS.md","CLAUDE.md","agent-manifest.yaml","codex/AGENTS.md",".agents/skills",".agents/agents",".agents/policies"]; let failed=false;
for(const x of required){const ok=existsSync(join(process.cwd(),x)); console.log(`${ok?"✓":"✗"} ${x}`); if(!ok) failed=true;}
const a=readFileSync("AGENTS.md","utf8").toLowerCase(); for(const x of ["production","runtime secrets","wf-10","wf-20"]){if(!a.includes(x)){console.error(`✗ AGENTS.md missing critical rule: ${x}`);failed=true;}}
process.exit(failed?1:0);
