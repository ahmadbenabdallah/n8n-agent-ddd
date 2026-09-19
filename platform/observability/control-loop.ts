export type DecisionClass =
  | "healthy"
  | "transient"
  | "degraded"
  | "critical"
  | "unknown_external_outcome";

export type OperationalAction =
  | "none"
  | "bounded_retry"
  | "alert_and_reconcile"
  | "freeze_and_escalate"
  | "reconcile_before_retry";

export interface ControlObservation {
  correlationId: string;
  component: string;
  health: "healthy" | "degraded" | "unhealthy" | "unknown";
  transientFailure: boolean;
  unknownExternalOutcome: boolean;
  criticalIntegrityFailure: boolean;
  humanOwnerActive: boolean;
  automationFrozen: boolean;
}

export interface ControlDecision {
  correlationId: string;
  classification: DecisionClass;
  action: OperationalAction;
  autonomous: boolean;
  reason: string;
}

export function classifyObservation(o: ControlObservation): DecisionClass {
  if (o.unknownExternalOutcome) return "unknown_external_outcome";
  if (o.criticalIntegrityFailure || o.health === "unhealthy") return "critical";
  if (o.transientFailure) return "transient";
  if (o.health === "degraded" || o.health === "unknown") return "degraded";
  return "healthy";
}

export function decideControlAction(o: ControlObservation): ControlDecision {
  const classification = classifyObservation(o);
  if (o.automationFrozen || o.humanOwnerActive) {
    return {
      correlationId: o.correlationId,
      classification,
      action: classification === "healthy" ? "none" : "freeze_and_escalate",
      autonomous: false,
      reason: o.automationFrozen
        ? "Automation is frozen by incident policy."
        : "Human ownership blocks conflicting autonomous automation.",
    };
  }

  switch (classification) {
    case "healthy":
      return { correlationId: o.correlationId, classification, action: "none", autonomous: true, reason: "No operational intervention required." };
    case "transient":
      return { correlationId: o.correlationId, classification, action: "bounded_retry", autonomous: true, reason: "Transient internal failure is eligible for bounded retry." };
    case "degraded":
      return { correlationId: o.correlationId, classification, action: "alert_and_reconcile", autonomous: true, reason: "Degraded runtime requires alerting and reconciliation." };
    case "critical":
      return { correlationId: o.correlationId, classification, action: "freeze_and_escalate", autonomous: false, reason: "Critical integrity/runtime failure requires a freeze and human escalation." };
    case "unknown_external_outcome":
      return { correlationId: o.correlationId, classification, action: "reconcile_before_retry", autonomous: true, reason: "External outcome is unknown; reconciliation must precede any retry." };
  }
}

export function exponentialBackoffMs(attempt: number, baseMs = 1_000, maxMs = 60_000): number {
  if (!Number.isInteger(attempt) || attempt < 0) throw new Error("attempt must be a non-negative integer");
  return Math.min(maxMs, baseMs * 2 ** attempt);
}
