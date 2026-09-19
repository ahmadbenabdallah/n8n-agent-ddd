export type ConfigurationClass =
  | "infrastructure"
  | "business"
  | "secret"
  | "workflow_extension"
  | "platform_core";

export interface CustomerRuntimeConfig {
  domainId: string;
  version: number;
  values: Record<string, unknown>;
  updatedBy: string;
  updatedAt: string;
}

export interface ConfigChange {
  domainId: string;
  key: string;
  value: unknown;
  actorId: string;
  expectedVersion: number;
  correlationId: string;
}

export interface ConfigDecision {
  allowed: boolean;
  reason: string;
  classification: ConfigurationClass | null;
}
