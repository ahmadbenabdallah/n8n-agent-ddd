export type IncidentState = "OPEN" | "ACKNOWLEDGED" | "MITIGATING" | "RESOLVED" | "ESCALATED" | "FROZEN";

const transitions: Record<IncidentState, IncidentState[]> = {
  OPEN: ["ACKNOWLEDGED", "ESCALATED", "FROZEN"],
  ACKNOWLEDGED: ["MITIGATING", "ESCALATED", "FROZEN"],
  MITIGATING: ["RESOLVED", "ESCALATED", "FROZEN"],
  RESOLVED: [],
  ESCALATED: ["MITIGATING", "RESOLVED", "FROZEN"],
  FROZEN: ["ESCALATED", "RESOLVED"],
};

export function canTransitionIncident(from: IncidentState, to: IncidentState): boolean {
  return transitions[from].includes(to);
}

export function transitionIncident(from: IncidentState, to: IncidentState): IncidentState {
  if (!canTransitionIncident(from, to)) {
    throw new Error(`Invalid incident transition: ${from} -> ${to}`);
  }
  return to;
}
