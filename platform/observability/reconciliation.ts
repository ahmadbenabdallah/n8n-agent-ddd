export type ReconciliationState =
  | "UNKNOWN"
  | "RECONCILING"
  | "VERIFIED_NOT_EXECUTED"
  | "VERIFIED_EXECUTED"
  | "CONFLICT"
  | "ESCALATED";

export interface ReconciliationRecord {
  reconciliationId: string;
  operationId: string;
  state: ReconciliationState;
  externalReference?: string;
  evidence: Record<string, unknown>;
  timestamp: string;
}

export function nextReconciliationState(
  current: ReconciliationState,
  verifiedExecuted: boolean | null,
): ReconciliationState {
  if (current === "ESCALATED") return current;
  if (verifiedExecuted === true) return "VERIFIED_EXECUTED";
  if (verifiedExecuted === false) return "VERIFIED_NOT_EXECUTED";
  if (current === "UNKNOWN") return "RECONCILING";
  return "CONFLICT";
}
