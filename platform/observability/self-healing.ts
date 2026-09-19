export type HealingAction =
  | "restart_disposable_worker"
  | "retry_transient_internal_operation"
  | "clear_stale_runtime_lock"
  | "reschedule_reconciliation";

const ALLOWED = new Set<HealingAction>([
  "restart_disposable_worker",
  "retry_transient_internal_operation",
  "clear_stale_runtime_lock",
  "reschedule_reconciliation",
]);

export interface HealingDecision {
  allowed: boolean;
  action: HealingAction;
  maxAttempts: number;
  reason: string;
}

export function authorizeHealing(action: HealingAction, attempt: number): HealingDecision {
  const maxAttempts = 3;
  return {
    allowed: ALLOWED.has(action) && attempt < maxAttempts,
    action,
    maxAttempts,
    reason: ALLOWED.has(action)
      ? "Bounded operational self-healing."
      : "Action is not permitted for autonomous healing.",
  };
}
