# Implementation Sequence

## Sprint 1
- database/state;
- channel normalization;
- idempotency;
- security gate.

## Sprint 2
- identity;
- product search;
- KB ingestion/retrieval;
- structured LLM output.

## Sprint 3
- action validator;
- cart;
- promotion;
- checkout.

## Sprint 4
- order support;
- escalation;
- analytics;
- language QA.

## Sprint 5
- OWASP red team;
- shadow;
- canary;
- production.

## Definition of Done

A workflow is not done until:
- inputs/outputs have schemas;
- permissions are enforced outside the LLM;
- errors are sanitized;
- audit events exist;
- idempotency exists for writes;
- tests pass;
- rollback is documented.
