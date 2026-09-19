# WF-06 n8n Implementation Blueprint

## Node sequence

```text
Execute Workflow Trigger
→ Load WF-03 state
→ Validate support intent
→ Human ownership gate
→ Identity/order-scope gate
→ Support policy classifier
→ Required-source router
→ KB retrieval OR downstream workflow
→ Build verified support context
→ Optional LLM structured response
→ Return proposal/answer envelope
→ Persist safe state changes
→ Emit support analytics
```

## Routing

```text
shipping/payment/policy
→ approved KB/policy

order_status
→ WF-07

return_exchange
→ policy + WF-07 if order facts required

complaint
→ support policy + live facts if needed
→ WF-08 when mandatory

payment_dispute
→ WF-08

human_request
→ WF-08

safety
→ approved safety path + WF-08 when required

security_suspicion
→ restricted path + WF-08
```

## Human gate

Do not continue conflicting automation when the active case owns the conversation.

## State

WF-06 may request state updates but WF-03 remains canonical.

Useful state fields:
- support intent
- support category
- ack state
- case ID
- last support action ID
- last verified fact timestamp
- escalation status

## Error codes

```text
WF06_INVALID_INTENT
WF06_MISSING_POLICY
WF06_LIVE_FACT_REQUIRED
WF06_IDENTITY_REQUIRED
WF06_SCOPE_INVALID
WF06_HUMAN_OWNED
WF06_POLICY_CONFLICT
WF06_SECURITY_ESCALATION
WF06_MANDATORY_ESCALATION
WF06_DEPENDENCY_UNAVAILABLE
WF06_UNVERIFIED_OPERATION
```

## Retry

Reads may use bounded retries.
Writes must follow the downstream workflow's idempotency contract.
Do not retry human-case creation blindly without an idempotency key.

## Secrets

No API credentials, payment secrets, WooCommerce secrets, Cart-Tokens or nonce tokens in prompts/logs/customer context.
