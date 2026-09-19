# n8n Workflow Architecture — Production v3

## Topology
Channels → WF-00 → WF-01 → WF-02 → WF-03 → WF-04 → WF-05/WF-06/WF-07 → WF-09 → WF-10 → WF-11–WF-15 → WF-20 → verification → WF-16 → channel send → WF-17.

WF-18 independently ingests/version-controls KB.
WF-19 monitors, reconciles, tests and maintains the system.

## Workflow contracts
WF-00: normalize, stable inbound ID, idempotency, bounded payload.
WF-01: security controls, prompt-injection/risk signals, rate limits.
WF-02: deterministic identity and order scope.
WF-03: canonical state.
WF-04: deterministic intent routing with LLM advisory classification where used.
WF-05: sales reasoning/business rules.
WF-06: support/policy flow.
WF-07: order service.
WF-08: escalation ownership.
WF-09: LLM structured reasoning.
WF-10: sole authorization.
WF-11: product service.
WF-12: cart service.
WF-13: promotion service.
WF-14: checkout service.
WF-15: transaction/reconciliation service.
WF-16: response rendering and language/script validation.
WF-17: safe audit/events.
WF-18: KB ingestion.
WF-19: maintenance/monitoring/DR.
WF-20: sole privileged WooCommerce boundary.

## Retry rule
Bounded retries for reads. Never blindly retry writes. Use idempotency and reconciliation after ambiguous outcomes.
