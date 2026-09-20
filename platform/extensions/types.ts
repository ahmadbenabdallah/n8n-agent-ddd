export type ExtensionLifecycle = "DRAFT" | "VALIDATED" | "ENABLED" | "DISABLED" | "INCOMPATIBLE" | "RETIRED";

export interface CustomerExtension {
  extensionId: string;
  version: string;
  owner: "customer" | "platform";
  type: "n8n_workflow" | "n8n_subworkflow" | "channel_adapter" | "notification" | "knowledge";
  compatibility: { runtime: string; domain: string };
  permissions: string[];
  workflows: string[];
  provenance: { source: "n8n" | "git"; createdBy: string; createdAt: string };
  lifecycle: ExtensionLifecycle;
}

/**
 * Workflow ids a domain marks `protected: true` in its own
 * `workflows/registry.yaml`. Protected workflows are platform-owned: the
 * operator cannot edit them in n8n and they are released from git.
 *
 * The platform never names a workflow id (ADR 0001). Callers resolve the set
 * for a domain and pass it in.
 */
export type ProtectedWorkflows = readonly string[];

export function isProtectedWorkflow(workflowKey: string, protectedWorkflows: ProtectedWorkflows): boolean {
  return protectedWorkflows.includes(workflowKey);
}
