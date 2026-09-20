import { isProtectedWorkflow, type ProtectedWorkflows } from "../extensions/types";

export function canCustomerEditWorkflow(
  workflowKey: string,
  protectedWorkflows: ProtectedWorkflows,
): boolean {
  return !isProtectedWorkflow(workflowKey, protectedWorkflows);
}

export function workflowOwnership(
  workflowKey: string,
  protectedWorkflows: ProtectedWorkflows,
): "platform_core" | "customer_extendable" {
  return canCustomerEditWorkflow(workflowKey, protectedWorkflows) ? "customer_extendable" : "platform_core";
}
