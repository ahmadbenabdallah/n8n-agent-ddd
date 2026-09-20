import { isProtectedWorkflow, type ProtectedWorkflows } from "../extensions/types";
import type { Surface, RuntimeOwner, WorkflowOwnershipRecord } from "./types";

export function workflowOwnership(
  workflowKey: string,
  protectedWorkflows: ProtectedWorkflows,
): WorkflowOwnershipRecord {
  const protectedWorkflow = isProtectedWorkflow(workflowKey, protectedWorkflows);
  return {
    domainId: "*",
    surface: protectedWorkflow ? "core" : "extension",
    owner: protectedWorkflow ? "platform" : "n8n",
    sourceOfTruth: protectedWorkflow ? "git" : "n8n",
    editableByOperator: !protectedWorkflow,
    releaseControlled: protectedWorkflow,
    workflowKey,
    n8nProject: "domain-runtime",
    editableInN8n: !protectedWorkflow,
    protected: protectedWorkflow,
  };
}

export function canOperatorChange(surface: Surface, owner: RuntimeOwner): boolean {
  if (surface === "core" || surface === "infrastructure") return false;
  if (surface === "secret") return owner === "secret_provider" || owner === "operator";
  return owner === "operator" || owner === "n8n";
}
