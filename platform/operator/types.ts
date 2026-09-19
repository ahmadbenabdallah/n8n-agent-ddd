export interface OperatorIdentity {
  operatorId: string;
  domainId: string;
  role: "owner" | "admin" | "editor" | "operator" | "viewer";
}

export interface OperatorRuntimeBinding {
  domainId: string;
  n8nProjectId: string;
  n8nProjectName: string;
  configurationNamespace: string;
  extensionNamespace: string;
}

export interface OperatorConfigurationPatch {
  domainId: string;
  expectedVersion: number;
  changes: Record<string, unknown>;
  actor: OperatorIdentity;
  correlationId: string;
}
