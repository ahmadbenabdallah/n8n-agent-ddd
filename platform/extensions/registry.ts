import { isProtectedWorkflow, type CustomerExtension, type ProtectedWorkflows } from "./types";

export function validateExtension(
  extension: CustomerExtension,
  protectedWorkflows: ProtectedWorkflows,
): string[] {
  const errors: string[] = [];
  if (extension.owner !== "customer") errors.push("Only customer-owned extensions belong in this registry.");
  if (!/^[a-z0-9][a-z0-9._-]{2,63}$/.test(extension.extensionId)) errors.push("Invalid extension_id.");
  if (extension.workflows.some((wf) => isProtectedWorkflow(wf, protectedWorkflows))) {
    errors.push("Extension cannot own or replace a protected workflow.");
  }
  if (extension.permissions.some((p) => ["commerce.authorization", "commerce.payment_mutation", "secret.export", "credential.export", "arbitrary_http.production"].includes(p))) {
    errors.push("Extension requests forbidden permission.");
  }
  if (!extension.compatibility.runtime || !extension.compatibility.domain) errors.push("Compatibility declaration is required.");
  return errors;
}
