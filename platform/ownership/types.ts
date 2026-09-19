export type RuntimeOwner = "platform" | "operator" | "n8n" | "secret_provider" | "infrastructure";
export type Surface = "core" | "configuration" | "extension" | "secret" | "infrastructure";

export interface OwnershipRecord {
  domainId: string;
  surface: Surface;
  owner: RuntimeOwner;
  sourceOfTruth: string;
  editableByOperator: boolean;
  releaseControlled: boolean;
}

export interface WorkflowOwnershipRecord extends OwnershipRecord {
  workflowKey: string;
  n8nProject: string;
  editableInN8n: boolean;
  protected: boolean;
}
