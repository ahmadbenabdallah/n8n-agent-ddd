import { PROTECTED_WORKFLOWS } from "../extensions/types";

export function canCustomerEditWorkflow(workflowKey: string): boolean {
  return !(PROTECTED_WORKFLOWS as readonly string[]).includes(workflowKey);
}

export function workflowOwnership(workflowKey: string): "platform_core" | "customer_extendable" {
  return canCustomerEditWorkflow(workflowKey) ? "customer_extendable" : "platform_core";
}
