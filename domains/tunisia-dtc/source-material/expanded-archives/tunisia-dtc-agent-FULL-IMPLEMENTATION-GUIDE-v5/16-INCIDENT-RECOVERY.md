# Incident & Recovery Runbooks

## 1. WooCommerce outage

Actions:
1. stop non-essential mutations;
2. continue safe read-only responses if data is available and freshness is acceptable;
3. surface uncertainty rather than inventing state;
4. alert operations;
5. reconcile queued/unknown mutations after recovery.

## 2. Unknown order creation

Do not blindly retry.

1. identify idempotency key;
2. query reconciliation path;
3. locate possible order;
4. verify expected customer/line items/totals;
5. mark execution verified or failed;
6. only then continue.

## 3. OpenAI outage

Fallback to deterministic paths:
- known product facts;
- known order status;
- human escalation;
- safe error response.

Do not bypass authorization because the LLM is unavailable.

## 4. Meta webhook outage

- monitor webhook health;
- preserve durable inbound records where possible;
- replay safely using idempotency;
- avoid duplicate commerce mutations.

## 5. Security incident

- quarantine affected workflow/source;
- disable dangerous mutation class if necessary;
- preserve audit evidence;
- rotate compromised credentials;
- investigate scope;
- restore from known-good version;
- run security regression tests before re-enable.

## 6. KB poisoning

- unpublish/quarantine version;
- restore prior approved version;
- identify affected retrieval events;
- re-run relevant tests;
- publish corrected source only after quality gate.

## 7. Human escalation outage

If notification fails:
- do not claim a human has been notified;
- record pending case;
- retry notification;
- surface an honest fallback acknowledgement.
