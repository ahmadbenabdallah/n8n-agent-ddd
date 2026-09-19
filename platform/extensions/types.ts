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

export const PROTECTED_WORKFLOWS = ["WF-01", "WF-10", "WF-15", "WF-20"] as const;
