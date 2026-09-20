export type HealthStatus = "healthy" | "degraded" | "unhealthy" | "unknown";

export interface HealthCheck {
  checkId: string;
  component: string;
  status: HealthStatus;
  latencyMs?: number;
  releaseVersion?: string;
  timestamp: string;
}

export function summarizeHealth(checks: HealthCheck[]) {
  if (checks.some((c) => c.status === "unhealthy")) return "unhealthy";
  if (checks.some((c) => c.status === "unknown")) return "unknown";
  if (checks.some((c) => c.status === "degraded")) return "degraded";
  return "healthy";
}
