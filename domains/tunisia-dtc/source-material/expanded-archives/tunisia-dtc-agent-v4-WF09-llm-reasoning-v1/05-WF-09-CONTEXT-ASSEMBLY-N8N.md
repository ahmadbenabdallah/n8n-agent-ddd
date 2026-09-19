# WF-09 n8n Context Assembly

## Node sequence

1. Execute Workflow Trigger
2. Receive canonical envelope
3. Validate required envelope fields
4. Remove forbidden fields/secrets
5. Load only relevant conversation state
6. Attach identity/order-scope context
7. Attach approved KB retrieval
8. Attach live commerce facts from upstream workflows
9. Attach allowed action catalog
10. Attach ownership/automation mode
11. Attach language/script constraints
12. Build immutable LLM input
13. OpenAI structured-output call
14. Parse JSON
15. Schema validation
16. Proposal sanitation
17. Send proposal to WF-10
18. Never execute from WF-09

## n8n rules
- Credentials live only in n8n credentials/environment secret storage.
- Do not place secrets in prompts or execution data.
- Disable unnecessary execution-data retention.
- Use bounded input lengths and output tokens.
- Apply timeout and retry policy without duplicating side effects.
- Retry model generation only when the operation is non-mutating.
- Every generation receives a request/correlation ID.
- Model output is untrusted until schema and policy validation.

## Failure handling
- Invalid JSON/schema → one bounded regeneration or deterministic safe fallback.
- Context missing → return a structured `CLARIFY`/`NO_ACTION` proposal.
- Model timeout → safe fallback; no action execution.
- Prompt injection signal → preserve security flag and route to WF-01/WF-08 as appropriate.
