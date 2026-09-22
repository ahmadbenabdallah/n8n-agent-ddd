#!/usr/bin/env node
// Instantiate templates/domain-pack into a new domain pack.
//
// The point is not convenience. Before this existed, the template was only
// ever copied by hand, so it kept Tunisia's workflow ids for a whole refactor
// without anyone noticing (see runtime/evidence/validation/F1.md). Every
// placeholder is either substituted here or listed in AUTHOR_FILLS; a
// placeholder in neither is a hard error, so template rot fails the test run
// that instantiates it rather than the adopter who copies it.
//
// Platform roles, not workflow ids (ADR 0001): the caller gives an id prefix
// and this maps the roles onto that prefix. Nothing here knows a literal id.
//
// Zero dependencies on purpose: the plugin ships this file and it has to run
// in a checkout that has not had `pnpm install` yet.

import { execFileSync } from "node:child_process";
import { existsSync, mkdirSync, readFileSync, readdirSync, writeFileSync } from "node:fs";
import { dirname, join, relative, resolve } from "node:path";

const USAGE = `Usage: node scaffold-domain.mjs --id <domain-id> --name "<Name>" --prefix <PREFIX>

  --id            domain id, lowercase kebab-case, e.g. demo-clinic
  --name          human-readable name, e.g. "Demo Clinic"
  --prefix        prefix for this domain's own workflow ids, e.g. CLIN
  --purpose       one sentence: who the agent serves, on what channel, doing what
  --context       id of the domain's primary bounded context   (default: operations)
  --responsibility  what that context owns
  --channel       channel adapter        (default: meta-messenger)
  --commerce      external system of record, or none  (default: none)
  --language      default language code  (default: en)
  --repo          framework checkout to read the template from (default: git root)
  --out           where to write the pack (default: <repo>/domains/<id>)
  --force         overwrite an existing pack
`;

// Placeholders the domain author fills in: the domain model itself, which no
// scaffold can invent. Everything else must be substituted below.
const AUTHOR_FILLS = new Set([
  "<EntityName>",
  "<entity_id>",
  "<attribute>",
  "<AggregateName>",
  "<ValueObjectName>",
  "<field>",
  "<DomainCommand>",
  "<DomainEvent>",
  "<view-name>",
  "<situation>",
  "<required outcome>",
  "<One verifiable business rule this domain must never break.>",
]);

function fail(message) {
  console.error(`scaffold-domain: ${message}`);
  process.exit(1);
}

function parseArgs(argv) {
  const opt = {};
  for (let i = 0; i < argv.length; i++) {
    const token = argv[i];
    if (token === "--help" || token === "-h") {
      console.log(USAGE);
      process.exit(0);
    }
    if (!token.startsWith("--")) fail(`unexpected argument: ${token}\n${USAGE}`);
    const key = token.slice(2);
    if (key === "force") {
      opt.force = true;
      continue;
    }
    const value = argv[++i];
    if (value === undefined) fail(`--${key} needs a value`);
    opt[key] = value;
  }
  return opt;
}

function gitRoot() {
  try {
    return execFileSync("git", ["rev-parse", "--show-toplevel"], { encoding: "utf8" }).trim();
  } catch {
    return process.cwd();
  }
}

function readTree(dir, base = dir, out = new Map()) {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const path = join(dir, entry.name);
    if (entry.isDirectory()) readTree(path, base, out);
    else if (entry.isFile()) out.set(relative(base, path).replaceAll("\\", "/"), readFileSync(path, "utf8"));
  }
  return out;
}

/** Roles mapped onto the caller's prefix, in the order the template's registry lists them. */
function planWorkflows(cfg) {
  const id = (suffix) => `${cfg.prefix}-${suffix}`;
  const authz = id("AUTHZ");
  const plan = [
    {
      id: id("IN"),
      name: `${cfg.channelLabel} inbound gateway`,
      context: cfg.context,
      deps: [id("GUARD")],
      purpose: `Terminates the ${cfg.channelLabel} webhook, verifies it, and hands the message to the security gate.`,
      security:
        "An inbound message whose origin cannot be verified is rejected. The gateway never authorizes.",
    },
    {
      id: id("GUARD"),
      name: "Prompt and input security gate",
      context: cfg.context,
      deps: [],
      purpose:
        "Screens inbound text for prompt injection, jailbreak patterns, oversized and disallowed input.",
      security:
        "Screening is not authorization. A message that passes the gate has been cleaned, not allowed.",
    },
    {
      id: authz,
      name: "Action authorization",
      context: "governance",
      role: "authorization",
      deps: [],
      purpose: "The only workflow that may allow an action in this domain.",
      security: "Fail closed. An unknown action, policy version or identity assurance is a denial.",
    },
    {
      id: id("REPLY"),
      name: "Response renderer",
      context: "governance",
      role: "response_rendering",
      deps: [authz],
      purpose: "Turns a completed decision into a customer-facing reply built from verified facts only.",
      security:
        "No unverified price, stock, order or payment claims. A proposal is never described as confirmed.",
    },
    {
      id: id("AUDIT"),
      name: "Audit writer",
      context: "governance",
      role: "audit",
      deps: [],
      purpose:
        "Records every state-changing action and every authorization decision as append-only evidence.",
      security:
        "Audit is not authorization. Writing a record never grants permission, and records never change.",
    },
    {
      id: id("RECON"),
      name: "Reconciliation and monitoring",
      context: "governance",
      role: "reconciliation",
      deps: [],
      purpose: "Settles operations whose outcome is unknown, and reports the domain's health.",
      security: "An unknown outcome is reconciled before any retry, never retried blind.",
    },
    {
      id: id("CORE"),
      name: `${cfg.name} business workflow`,
      context: cfg.context,
      deps: [authz],
      purpose: "This domain's own business logic. Replace with the workflow the business actually needs.",
      security:
        "Proposes actions; it cannot allow one. Every privileged step goes through the authorization role.",
    },
  ];

  if (cfg.commerce !== "none") {
    plan.push({
      id: id("EXEC"),
      name: `Privileged execution against ${cfg.commerce}`,
      context: "governance",
      role: "privileged_external_execution",
      deps: [authz],
      purpose: `The only workflow that may change ${cfg.commerce}, and only on an authorized decision.`,
      security: "Never callable by the LLM and never callable without an authorization decision.",
    });
  }
  return plan;
}

/** Role-specific invariants the platform validators look for in the workflow contract. */
function roleBlock(workflow) {
  switch (workflow.role) {
    case "authorization":
      return [
        "  role: authorization",
        "",
        "  # Platform invariants for the authorization role (AUTH-001, AUTH-002).",
        "  llm_can_authorize: false",
        "  only_authorized_branch_can_set_execution_allowed: true",
        "",
      ];
    case "privileged_external_execution":
      return [
        "  role: privileged_external_execution",
        "",
        "  # Platform invariants for the privileged execution role (EXEC-001).",
        "  callable_by_llm: false",
        "  callable_without_authorization: false",
        "  arbitrary_endpoint: false",
        "  client_supplied_price: false",
        "",
      ];
    case "response_rendering":
      return ["  role: response_rendering", "  source: verified_facts_only", ""];
    case "audit":
      return ["  role: audit", "  append_only: true", ""];
    case "reconciliation":
      return ["  role: reconciliation", ""];
    default:
      return [];
  }
}

function renderWorkflow(template, workflow) {
  let text = template
    .replace("<workflow id>", workflow.id)
    .replace("<Workflow name>", workflow.name)
    .replace("<context-id>", workflow.context)
    .replace("<What this workflow does.>", workflow.purpose)
    .replace("<The boundary this workflow must never cross.>", workflow.security);

  const deps = workflow.deps.length
    ? `  dependencies:\n${workflow.deps.map((d) => `  - ${d}\n`).join("")}`
    : "";
  text = text.replace(/ {2}dependencies:\n {2}- <authorization workflow id>[^\n]*\n/, deps);

  const block = roleBlock(workflow);
  if (block.length > 0) text = text.replace("  observability:", `${block.join("\n")}  observability:`);
  return text;
}

function renderRegistry(template, cfg, workflows) {
  let text = template
    .replaceAll("<your-domain-id>", cfg.id)
    .replaceAll("<YYYY.MM.N>", cfg.version)
    .replace("<Inbound gateway for your channel>", workflows[0].name)
    .replace("<Security gate>", workflows[1].name)
    .replace("<Action authorization>", workflows[2].name)
    .replace("<Response renderer>", workflows[3].name)
    .replace("<Audit>", workflows[4].name)
    .replace("<Reconciliation and monitoring>", workflows[5].name)
    .replace("<Your business workflow, e.g. booking engine>", workflows[6].name);

  // The template lists `<ID>` once per entry, in the same order as the plan.
  let next = 0;
  text = text.replace(/<ID>/g, () => workflows[next++].id);

  // The library only carries a Meta Messenger gateway; another channel adopts nothing.
  text =
    cfg.channel === "meta-messenger"
      ? text.replace(/^ {2}from_library: messenger-inbound[^\n]*$/m, "  from_library: messenger-inbound")
      : text.replace(/^ {2}from_library: messenger-inbound[^\n]*\n/m, "");

  const exec = workflows.find((w) => w.role === "privileged_external_execution");
  if (exec) {
    text += [
      `- id: ${exec.id}`,
      `  name: ${exec.name}`,
      "  category: execution",
      "  scope: domain",
      "  protected: true",
      "",
    ].join("\n");
  }
  return text;
}

function renderDomain(template, cfg, workflows) {
  const role = (name) => workflows.find((w) => w.role === name)?.id;
  let text = template
    .replaceAll("<your-domain-id>", cfg.id)
    .replace("<Human-readable name>", cfg.name)
    .replaceAll("<YYYY.MM.N>", cfg.version)
    .replace("<Who the agent serves, on which channels, doing what.>", cfg.purpose)
    .replace("<context-id>", cfg.context)
    .replace("<What this context owns.>", cfg.responsibility)
    .replace("<external system, e.g. commerce platform or channel>", cfg.channel.replaceAll("-", "_"))
    .replace("<LEVEL>", "CHANNEL_VERIFIED")
    .replace("<language code>", cfg.language)
    .replace("<commerce system, or none>", cfg.commerce);

  // The trailing "# required: ..." comments are instructions to whoever fills
  // the template in, and scripts/lib/domain-roles.ts only reads a role line
  // that ends at the id. Consume them along with the placeholder.
  for (const name of ["authorization", "response_rendering", "audit", "reconciliation"]) {
    text = text.replace(new RegExp(`^( {2}${name}: )<workflow id>[^\\n]*`, "m"), `$1${role(name)}`);
  }
  const exec = role("privileged_external_execution");
  text = exec
    ? text.replace(/^( {2}privileged_external_execution: )<workflow id>[^\n]*/m, `$1${exec}`)
    : // No external system of record, so the platform does not require the role
      // (demo-booking proves this path). Leaving a placeholder would fail validation.
      text.replace(/^ {2}privileged_external_execution: <workflow id>[^\n]*\n/m, "");
  return text;
}

function renderPolicies(template, cfg, workflows) {
  const role = (name) => workflows.find((w) => w.role === name)?.id;
  let text = template
    .replace("<authorization workflow id>", role("authorization"))
    .replace("<response rendering workflow id>", role("response_rendering"));

  const exec = role("privileged_external_execution");
  text = exec
    ? text.replace("<privileged execution workflow id>", exec).replace("<commerce system>", cfg.commerce)
    : text.replace(
        / {2}commerce_execution:[^\n]*\n(?: {4}[^\n]*\n)+/,
        "  # No commerce_execution policy: this domain changes no external system.\n",
      );
  return text;
}

function renderReadme(cfg, workflows, todos) {
  const rows = workflows.map((w) => `| \`${w.id}\` | ${w.name} | ${w.role ?? "—"} |`).join("\n");
  const todoList =
    todos.length === 0
      ? "None: every placeholder was filled.\n"
      : `${todos.map((t) => `- \`${t.file}\`: \`${t.placeholder}\``).join("\n")}\n`;
  return `# ${cfg.name}

Scaffolded from \`templates/domain-pack\` by the \`domain-builder\` plugin.

${cfg.purpose}

## Workflows

Ids belong to this domain. The platform defines roles and maps nothing.

| Id | Name | Platform role |
|---|---|---|
${rows}

External system of record: \`${cfg.commerce}\`.${
    cfg.commerce === "none"
      ? " With no external system to change, the platform does not require\nthe `privileged_external_execution` role, so this pack declares four roles."
      : ""
  }

## Still to write

The scaffold fills the platform contract. The domain model is yours:

${todoList}
Then run \`pnpm validate\`.
`;
}

const opt = parseArgs(process.argv.slice(2));
for (const key of ["id", "name", "prefix"]) if (!opt[key]) fail(`--${key} is required\n${USAGE}`);
if (!/^[a-z][a-z0-9-]*$/.test(opt.id)) fail(`--id must be lowercase kebab-case, got: ${opt.id}`);
if (!/^[A-Z][A-Z0-9]*$/.test(opt.prefix))
  fail(`--prefix must be uppercase letters/digits, got: ${opt.prefix}`);

const now = new Date();
const channel = opt.channel ?? "meta-messenger";
const cfg = {
  channel,
  channelLabel: channel.replace(/(^|-)([a-z])/g, (_, sep, c) => (sep ? " " : "") + c.toUpperCase()),
  id: opt.id,
  name: opt.name,
  prefix: opt.prefix,
  schema: opt.id.replaceAll("-", "_"),
  version: `${now.getUTCFullYear()}.${String(now.getUTCMonth() + 1).padStart(2, "0")}.1`,
  context: opt.context ?? "operations",
  responsibility: opt.responsibility ?? "The business decisions this domain owns.",
  commerce: opt.commerce ?? "none",
  language: opt.language ?? "en",
  purpose: opt.purpose ?? `${opt.name} serves customers over ${channel}. Replace this line.`,
};

const repo = resolve(opt.repo ?? gitRoot());
const templateDir = join(repo, "templates", "domain-pack");
if (!existsSync(templateDir))
  fail(`no template at ${templateDir}; run this inside an n8n-agent-ddd checkout`);
const out = resolve(opt.out ?? join(repo, "domains", cfg.id));
if (existsSync(out) && !opt.force) fail(`${out} already exists; pass --force to overwrite`);

const template = readTree(templateDir);
const exampleWorkflow = template.get("workflows/EXAMPLE-WF/workflow.yaml");
if (!exampleWorkflow) fail("the template has no workflows/EXAMPLE-WF/workflow.yaml to instantiate");

const workflows = planWorkflows(cfg);
const files = new Map();

for (const [path, text] of template) {
  // The template README explains how to copy the template; a live pack gets its own.
  if (path === "README.md" || path.startsWith("workflows/EXAMPLE-WF/")) continue;
  if (path === "domain.yaml") files.set(path, renderDomain(text, cfg, workflows));
  else if (path === "workflows/registry.yaml") files.set(path, renderRegistry(text, cfg, workflows));
  else if (path === "policies/policy-catalog.yaml") files.set(path, renderPolicies(text, cfg, workflows));
  else
    files.set(
      path,
      text
        .replaceAll("<your-domain-id>", cfg.id)
        .replaceAll("<your_domain_id>", cfg.schema)
        .replaceAll("<AREA>", cfg.prefix)
        .replaceAll("<YYYY.MM.N>", cfg.version)
        .replaceAll("<channel adapter, e.g. meta-messenger>", cfg.channel)
        .replaceAll("<commerce adapter, e.g. woocommerce, or none>", cfg.commerce),
    );
}
for (const workflow of workflows) {
  files.set(`workflows/${workflow.id}/workflow.yaml`, renderWorkflow(exampleWorkflow, workflow));
}

// Anything left over is either the author's to write, or template rot the
// scaffold does not know about. The second kind is a bug, here and now.
const todos = [];
const unknown = [];
for (const [path, text] of files) {
  for (const match of text.matchAll(/<[^<>\n]{1,160}>/g)) {
    (AUTHOR_FILLS.has(match[0]) ? todos : unknown).push({ file: path, placeholder: match[0] });
  }
  // ADR 0001: the platform names no workflow id, so neither may generated output.
  const leaked = text.match(/\bWF-\d{2}\b/);
  if (leaked) unknown.push({ file: path, placeholder: `${leaked[0]} (reference-domain workflow id)` });
}
if (unknown.length > 0) {
  console.error("scaffold-domain: the template contains something this scaffold cannot fill:");
  for (const u of unknown) console.error(`  ${u.file}: ${u.placeholder}`);
  console.error("Update plugins/domain-builder/scripts/scaffold-domain.mjs, or fix the template.");
  process.exit(1);
}

files.set("README.md", renderReadme(cfg, workflows, todos));

for (const [path, text] of files) {
  const target = join(out, path);
  mkdirSync(dirname(target), { recursive: true });
  writeFileSync(target, text);
}

console.log(`Scaffolded ${cfg.name} into ${out}`);
for (const workflow of workflows) {
  console.log(`  ${workflow.id.padEnd(16)} ${workflow.role ? `role: ${workflow.role}` : workflow.name}`);
}
console.log(
  todos.length === 0
    ? "\nNo placeholders left."
    : `\n${todos.length} domain-model placeholders left for you; see ${cfg.id}/README.md.`,
);
