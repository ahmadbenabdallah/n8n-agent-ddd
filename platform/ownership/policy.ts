import { PROTECTED_WORKFLOWS } from "../extensions/types";
import type { Surface, RuntimeOwner, WorkflowOwnershipRecord } from "./types";

export function workflowOwnership(workflowKey: string): WorkflowOwnershipRecord {
  const protectedWorkflow = (PROTECTED_WORKFLOWS as readonly string[]).includes(workflowKey);
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
