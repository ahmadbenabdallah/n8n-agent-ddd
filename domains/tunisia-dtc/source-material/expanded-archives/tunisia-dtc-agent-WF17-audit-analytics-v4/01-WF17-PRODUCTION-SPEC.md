# WF-17 Production Specification

## 1. Purpose

Capture enough structured evidence to answer:

1. What request entered the system?
2. Which workflow handled it?
3. What identity state existed?
4. What order scope existed?
5. What did the LLM propose?
6. What did WF-10 authorize or deny?
7. What actually executed?
8. What did commerce verify afterward?
9. What response was rendered?
10. Was it delivered?
11. Was a human involved?
12. Did any security/risk condition occur?
13. What latency, retry, or reconciliation occurred?

## 2. Trust model

WF-17 receives events from workflows but does not convert an event into permission.

An event such as:

```json
{
  "authorization_result": "AUTHORIZED"
}
```

is evidence of a WF-10 decision, not an authorization instruction for WF-17 or any other workflow.

## 3. Required correlation

Every event should be traceable through:

- `event_id`
- `correlation_id`
- `request_id`
- `conversation_id`
- `action_id` when applicable
- `response_id` when applicable
- `case_id` when applicable
- `commerce_operation_id` when applicable
- timestamp

Do not use customer-visible identifiers as the primary correlation key.

## 4. Event lifecycle

Recommended action lifecycle:

```text
RECEIVED
  -> NORMALIZED
  -> SECURITY_CHECKED
  -> IDENTITY_RESOLVED
  -> INTENT_RESOLVED
  -> LLM_PROPOSED
  -> AUTHORIZED / DENIED
  -> EXECUTING
  -> SUCCEEDED / FAILED / UNKNOWN
  -> VERIFIED / RECONCILIATION_REQUIRED
  -> RENDERED
  -> DELIVERED / DELIVERY_FAILED
```

Human path:

```text
ESCALATION_TRIGGERED
  -> HUMAN_REQUESTED
  -> HUMAN_ASSIGNED
  -> HUMAN_IN_PROGRESS
  -> HUMAN_RESOLVED
  -> AI_RELEASED
```

## 5. Event immutability

Events should be append-only from the application's perspective.

Corrections should create a new compensating/audit event rather than silently rewriting historical evidence.

## 6. Data minimization

Auditability does not justify collecting everything.

Never store:
- PAN;
- CVV;
- OTP/PIN;
- passwords;
- API keys;
- OAuth secrets;
- WooCommerce credentials;
- Cart-Tokens;
- Nonce Tokens;
- hidden prompts;
- full private message content unless explicitly approved by retention policy.

Prefer hashes, redacted fields, typed metadata, and references.
