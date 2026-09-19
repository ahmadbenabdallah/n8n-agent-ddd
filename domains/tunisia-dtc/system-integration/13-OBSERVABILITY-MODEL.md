# Integrated Observability

Every request should be correlatable through:
- correlation_id;
- request_id;
- conversation_id.

Where applicable:
- action_id;
- authorization_id reference;
- commerce_operation_id;
- response_id;
- case_id;
- ingestion_run_id.

Core metrics:
- request success/failure;
- authorization denial;
- commerce execution/verification;
- unknown/reconciliation;
- payment state;
- human handoff;
- response validation;
- delivery;
- LLM usage;
- security events;
- KB freshness;
- dependency health.

WF-17 owns audit evidence.
WF-19 owns operational monitoring.
