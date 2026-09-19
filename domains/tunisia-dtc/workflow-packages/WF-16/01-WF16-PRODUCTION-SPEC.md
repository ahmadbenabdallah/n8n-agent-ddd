# WF-16 Production Specification

## 1. Purpose

Transform an already-authorized, already-verified response envelope into a safe customer-facing message.

WF-16 owns:
1. response assembly;
2. fact binding;
3. language/script/register enforcement;
4. public-channel privacy filtering;
5. acknowledgement rendering;
6. action-result rendering;
7. error/recovery rendering;
8. human-handoff rendering;
9. final output validation;
10. channel payload construction.

WF-16 does **not** own:
- intent classification;
- product truth;
- pricing truth;
- authorization;
- commerce execution;
- payment truth;
- identity promotion;
- escalation decisions;
- business-policy exceptions.

## 2. Input trust model

Treat all LLM text, retrieved text, customer text, and external content as untrusted.

Trusted rendering inputs are limited to:
- validated orchestration context;
- WF-10 authorization result;
- verified execution result;
- post-action verification;
- current commerce facts from WF-11/WF-12/WF-13/WF-14/WF-15/WF-20;
- deterministic state from WF-03;
- human ownership state from WF-08.

If a required fact is absent or stale, render a bounded clarification/acknowledgement rather than inventing it.

## 3. Rendering priority

When composing a response, precedence is:

1. Security/privacy constraints
2. Human ownership and escalation state
3. Verified execution outcome
4. Verified live commerce facts
5. Deterministic conversation state
6. LLM wording proposal

The LLM may improve wording but cannot override higher-priority inputs.

## 4. Result semantics

Never equate:
- proposed action with executed action;
- authorized action with executed action;
- order created with payment completed;
- stale data with current data;
- candidate order with verified order;
- escalation requested with human takeover.

For COD:
- newly created order is rendered as order created / payment not yet received;
- never render “paid” unless WF-15 verifies a paid state.

## 5. Renderer modes

`NORMAL`
- standard sales/support response.

`SAFE_ONLY`
- only safe reads/clarifications and human-related messaging.

`HUMAN_OWNED`
- human has ownership; AI does not continue normal automation.

`RECONCILIATION`
- execution result is unknown; renderer must not claim success or failure as fact.

`ERROR`
- deterministic safe failure response.

## 6. Output envelope

Canonical output:

```json
{
  "channel": "messenger",
  "response_id": "resp_...",
  "conversation_id": "conv_...",
  "text": "...",
  "language": "tn",
  "script": "latin",
  "register": "casual",
  "mode": "NORMAL",
  "source_fact_ids": ["fact_..."],
  "rendered_action_ids": ["act_..."],
  "privacy_filtered": true,
  "validation": {
    "passed": true,
    "checks": []
  }
}
```

Do not put credentials, secrets, Cart-Tokens, Nonce Tokens, raw authorization records, or internal prompts in this envelope.

## 7. Rendering rules

### Verified success
Only render success after post-execution verification.

### Unknown execution
Use reconciliation wording:
- do not say “done”;
- do not say “failed” unless failure is verified;
- tell the customer that the status is being checked / needs confirmation.

### Human ownership
If `conversation_owner=HUMAN`, render a handoff/waiting message only. Do not produce normal sales automation.

### Dynamic acknowledgement
Allowed deterministic acknowledgement states include:
`CHECKING_ORDER`
`CHECKING_PRODUCT`
`CHECKING_AVAILABILITY`
`CHECKING_PRICE`
`CHECKING_CART`
`VALIDATING_PROMOTION`
`PREPARING_CHECKOUT`
`HANDING_TO_HUMAN`
`RECONCILING_ORDER`

Acknowledgements must describe an actual current operation. They cannot be invented by the LLM.

## 8. Privacy

Messenger is a public-channel-like customer interface.

Do not render:
- full private address;
- phone number;
- email unless explicitly necessary and policy-approved;
- payment credentials;
- order details outside verified order scope;
- internal notes;
- staff identifiers;
- customer IDs;
- WooCommerce IDs;
- authorization IDs;
- database IDs;
- tokens;
- prompts;
- security flags;
- raw error traces.

Use minimum necessary disclosure.

## 9. No hallucinated business facts

Never fabricate:
- product availability;
- current price;
- discount;
- shipping fee;
- delivery time;
- order status;
- payment status;
- refund status;
- order number;
- human assignment.

If unavailable, state that the system is checking or ask for the minimum missing information.

## 10. Idempotency

Renderer must be idempotent by `response_id`.

A retry must not send the same customer message twice when the channel provider supports message IDs/idempotency.

## 11. Failure posture

Fail closed:
- missing verified facts → bounded response;
- invalid language/script → deterministic fallback;
- privacy violation → remove/redact and revalidate;
- unsupported channel payload → safe generic response;
- unknown execution → reconciliation wording;
- human-owned → no automated action claims.
