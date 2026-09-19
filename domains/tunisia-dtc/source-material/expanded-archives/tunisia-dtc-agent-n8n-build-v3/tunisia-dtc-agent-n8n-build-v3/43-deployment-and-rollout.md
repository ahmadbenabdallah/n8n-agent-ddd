# Deployment & Rollout

## Phase 0 — Offline

- seed KB;
- run unit tests;
- run retrieval evaluation;
- run security tests;
- validate schemas.

## Phase 1 — Shadow

Receive production-like traffic but:
- no customer-facing send;
- no commerce writes.

Compare:
- intent;
- retrieval;
- proposed actions;
- escalation.

## Phase 2 — Canary

Enable a small percentage of conversations.

Start read-only:
- product;
- shipping;
- order status.

Then enable:
- cart;
- checkout.

Only after stable results should additional write actions be considered.

## Phase 3 — Production

Monitor:
- errors;
- cost;
- security events;
- conversion;
- escalation;
- latency.

Maintain immediate rollback to human-only mode.
