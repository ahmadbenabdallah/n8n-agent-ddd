import assert from "node:assert/strict";
import { decideControlAction, exponentialBackoffMs } from "../../../platform/observability/control-loop";
import { transitionIncident } from "../../../platform/observability/incident";
import { evaluateBudget } from "../../../platform/observability/budget";
import { normalizedHash } from "../../../platform/observability/drift";

const base = { correlationId: "c-1", component: "n8n", health: "healthy" as const, transientFailure: false, unknownExternalOutcome: false, criticalIntegrityFailure: false, humanOwnerActive: false, automationFrozen: false };

assert.equal(decideControlAction(base).action, "none");
assert.equal(decideControlAction({ ...base, transientFailure: true }).action, "bounded_retry");
assert.equal(decideControlAction({ ...base, health: "degraded" }).action, "alert_and_reconcile");
assert.equal(decideControlAction({ ...base, unknownExternalOutcome: true }).action, "reconcile_before_retry");
assert.equal(decideControlAction({ ...base, criticalIntegrityFailure: true }).action, "freeze_and_escalate");
assert.equal(decideControlAction({ ...base, transientFailure: true, humanOwnerActive: true }).autonomous, false);
assert.equal(exponentialBackoffMs(0), 1000);
assert.equal(exponentialBackoffMs(10), 60000);
assert.equal(transitionIncident("OPEN", "ACKNOWLEDGED"), "ACKNOWLEDGED");
assert.throws(() => transitionIncident("RESOLVED", "MITIGATING"));
assert.equal(evaluateBudget(7.9, { dailyUsd: 10, warningRatio: 0.8, hardStopRatio: 1 }).status, "ok");
assert.equal(evaluateBudget(8, { dailyUsd: 10, warningRatio: 0.8, hardStopRatio: 1 }).status, "warning");
assert.equal(evaluateBudget(10, { dailyUsd: 10, warningRatio: 0.8, hardStopRatio: 1 }).status, "exceeded");
assert.equal(normalizedHash({ b: 2, a: { d: 4, c: 3 } }), normalizedHash({ a: { c: 3, d: 4 }, b: 2 }));
console.log("PASS: Phase 12 executable control-loop invariants");
