# Platform

The platform is domain-agnostic. It provides the reusable control plane and contracts for autonomous n8n agents.

## Boundaries

- `identity/` — identity and assurance.
- `authorization/` — action authorization.
- `state/` — durable state machines and idempotency.
- `events/` — domain event conventions.
- `audit/` — immutable audit requirements.
- `reconciliation/` — recovery from unknown external outcomes.
- `observability/` — health, metrics and correlation.
- `contracts/` — machine-readable boundaries.

Business-specific rules belong in `domains/`, not here.
