import type { CapabilityDescriptor, CapabilityDecision } from "./types";

const DENY_BY_DEFAULT = new Set([
  "secret.read",
  "credential.export",
  "arbitrary_http",
  "commerce.mutation",
  "payment.mutation",
]);

export function evaluateToolPolicy(
  capability: CapabilityDescriptor,
  requestedPermission: string,
): CapabilityDecision {
  if (DENY_BY_DEFAULT.has(requestedPermission)) {
    return {
      allowed: false,
      reason: "Protected capability requires an explicit policy and, where applicable, runtime authorization.",
      matchedPolicyIds: ["TOOL-DENY-DEFAULT"],
    };
  }

  const allowed = capability.permissions.includes(requestedPermission);
  return {
    allowed,
    reason: allowed ? "Permission declared by capability." : "Permission not declared.",
    matchedPolicyIds: allowed ? ["TOOL-DECLARED-PERMISSION"] : ["TOOL-NOT-DECLARED"],
  };
}
