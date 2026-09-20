import { existsSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";

type Status = "PASS" | "FAIL" | "BLOCKED" | "EXPIRED";
type Evidence = {
  id: string;
  gate: string;
  status: Status;
  timestamp: string;
  release: string;
  findings?: Array<{ severity?: string; status?: string }>;
};

const required = [
  "INT",
  "SEC",
  "E2E",
  "IDEMP",
  "RECON",
  "RT",
  "LOAD",
  "DR",
  "BG",
  "DRIFT",
  "ARCH",
  "SECURITY",
];

const root = process.env.EVIDENCE_ROOT ?? "runtime/evidence/phase-10/runs";
const evidence: Evidence[] = [];

if (existsSync(root)) {
  for (const run of readdirSync(root, { withFileTypes: true })) {
    if (!run.isDirectory()) continue;
    const dir = join(root, run.name);
    for (const file of readdirSync(dir)) {
      if (!file.endsWith(".json")) continue;
      try {
        const item = JSON.parse(readFileSync(join(dir, file), "utf8"));
        if (item?.gate && item?.status) evidence.push(item);
      } catch {
        // Invalid evidence is ignored and therefore leaves the gate missing.
      }
    }
  }
}

const latest: Record<string, Evidence> = {};
for (const item of evidence) {
  const previous = latest[item.gate];
  if (!previous || new Date(item.timestamp).getTime() > new Date(previous.timestamp).getTime()) {
    latest[item.gate] = item;
  }
}

const failures: string[] = [];
for (const gate of required) {
  if (!latest[gate]) failures.push(`${gate}:missing`);
  else if (latest[gate].status !== "PASS") failures.push(`${gate}:${latest[gate].status}`);
}

let critical = 0;
let high = 0;
for (const item of Object.values(latest)) {
  for (const finding of item.findings ?? []) {
    if (finding.status === "OPEN" && finding.severity === "critical") critical++;
    if (finding.status === "OPEN" && finding.severity === "high") high++;
  }
}

const approvals = {
  architecture: latest["ARCH"]?.status === "PASS",
  security: latest["SECURITY"]?.status === "PASS",
};

const certified =
  failures.length === 0 && critical === 0 && high === 0 && approvals.architecture && approvals.security;

const decision = {
  release: "0.10.0",
  decision: certified ? "CERTIFIED" : "BLOCKED",
  generated_at: new Date().toISOString(),
  gates: Object.fromEntries(required.map((g) => [g, latest[g]?.status ?? "MISSING"])),
  open_critical_findings: critical,
  open_high_findings: high,
  approvals,
};

const out = process.env.CERTIFICATION_OUTPUT ?? "runtime/evidence/phase-10/certification.json";
writeFileSync(out, JSON.stringify(decision, null, 2) + "\n");
console.log(JSON.stringify(decision, null, 2));
if (!certified) process.exitCode = 2;
