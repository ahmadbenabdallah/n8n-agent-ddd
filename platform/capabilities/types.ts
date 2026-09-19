export type CapabilityKind = "skill" | "tool" | "plugin" | "mcp";

export interface CapabilityDescriptor {
  id: string;
  kind: CapabilityKind;
  version: string;
  domainScopes?: string[];
  permissions: string[];
  policyIds: string[];
}

export interface CapabilityDecision {
  allowed: boolean;
  reason: string;
  matchedPolicyIds: string[];
}
