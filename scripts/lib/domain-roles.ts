import { readFileSync } from "node:fs";
import { join } from "node:path";

// Roles every domain must fill. privileged_external_execution is required only
// when the domain changes an external business system (see domain.yaml
// sources_of_truth.commerce).
export const REQUIRED_ROLES = ["authorization", "response_rendering", "audit", "reconciliation"];
export const EXTERNAL_EXECUTION_ROLE = "privileged_external_execution";

export function domainPath(domain: string, ...parts: string[]) {
  return join(process.cwd(), "domains", domain, ...parts);
}

export function workflowSpecPath(domain: string, workflowId: string) {
  return domainPath(domain, "workflows", workflowId, "workflow.yaml");
}

/** Read the workflow_roles block of a domain: role -> the domain's workflow id. */
export function readWorkflowRoles(domain: string): Record<string, string> {
  const contents = readFileSync(domainPath(domain, "domain.yaml"), "utf8");
  const block = contents.split(/^workflow_roles:\s*$/m)[1];
  if (!block) return {};

  const roles: Record<string, string> = {};
  for (const line of block.split("\n")) {
    if (/^\S/.test(line)) break; // dedent ends the block
    const match = line.match(/^\s+([a-z_]+):\s*(\S+)\s*$/);
    if (match) roles[match[1]] = match[2];
  }
  return roles;
}

/** Workflow ids listed in a domain's own registry. */
export function readRegistryIds(domain: string): string[] {
  const contents = readFileSync(domainPath(domain, "workflows", "registry.yaml"), "utf8");
  return [...contents.matchAll(/^-\s*id:\s*(\S+)/gm)].map((m) => m[1]);
}

/**
 * Workflow ids the domain marks `protected: true` in its registry.
 * Protected workflows are platform-owned: released from git, not editable by
 * the operator in n8n. The platform never names an id (ADR 0001).
 */
export function readProtectedWorkflows(domain: string): string[] {
  const contents = readFileSync(domainPath(domain, "workflows", "registry.yaml"), "utf8");
  const protectedIds: string[] = [];
  let current: string | null = null;
  for (const line of contents.split(/\r?\n/)) {
    const id = line.match(/^-\s*id:\s*(\S+)/);
    if (id) {
      current = id[1];
      continue;
    }
    if (current && /^\s+protected:\s*true\s*$/.test(line)) protectedIds.push(current);
  }
  return protectedIds;
}

/** Does this domain change an external business system? */
export function mutatesExternalSystem(domain: string): boolean {
  const contents = readFileSync(domainPath(domain, "domain.yaml"), "utf8");
  const commerce = contents.match(/^\s+commerce:\s*(\S+)/m)?.[1];
  return Boolean(commerce) && commerce !== "none" && !commerce!.startsWith("<");
}
