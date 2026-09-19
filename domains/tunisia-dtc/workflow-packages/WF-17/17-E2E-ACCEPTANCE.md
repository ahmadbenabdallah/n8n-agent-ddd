# WF-17 E2E Acceptance

## A. Normal product flow
Request → product lookup → response. All major lifecycle events correlated.

## B. Cart flow
Authorization → mutation → verification → rendering. No missing action lifecycle.

## C. COD checkout
Order creation and payment state remain separate in analytics.

## D. Website-originated order
Identity and order scope transitions are auditable without logging proof secrets.

## E. Human handoff
Trigger → case → assignment → human work → resolution → release.

## F. Unknown execution
Unknown result → reconciliation → verified outcome.

## G. Security incident
Detection → security event → operational alert → customer-safe response.

## H. Delivery failure
Response rendered → delivery failed → retry → delivered, with no duplicated commerce action.

## I. Audit outage
Business workflow produces durable outbox record; later ingestion creates the audit event exactly once.

## Acceptance gate

All event-schema, redaction, idempotency, lifecycle, security, human-ownership and commerce-state tests must pass.
