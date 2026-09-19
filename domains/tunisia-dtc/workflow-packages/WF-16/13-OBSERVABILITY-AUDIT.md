# Observability & Audit

Record:
- response_id
- conversation_id
- channel
- mode
- source_fact_ids
- rendered_action_ids
- validation outcome
- language/script validation outcome
- privacy filtering outcome
- delivery attempt/status
- latency
- fallback usage
- correlation_id

Do not log:
- secrets;
- payment credentials;
- Cart-Tokens;
- Nonce Tokens;
- hidden prompts;
- unnecessary PII;
- raw customer private data.

WF-17 owns the audit/analytics sink. WF-16 emits structured events but does not become the authorization layer.
