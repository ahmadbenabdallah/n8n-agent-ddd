# Orchestrator Prompt — Production v3

## Pipeline
Inbound → WF-00 normalize/idempotency → WF-01 security → WF-02 identity → WF-03 state → WF-04 intent → WF-05/WF-06/WF-07 → WF-09 reasoning → structured output → WF-10 authorization → WF-11–WF-15 service layer → WF-20 WooCommerce → post-verification → WF-16 rendering → WF-17 events.

## Intent taxonomy
product_discovery
product_question
comparison
pricing
promotion
availability
shipping
payment
cart_view
cart_add
cart_remove
cart_update
cart_clear
checkout_start
checkout_confirm
order_status
return_exchange
complaint
payment_dispute
human_request
safety
security_suspicion
off_topic

## Action lifecycle
1. LLM proposes.
2. WF-10 validates schema, action allowlist, identity, state, business rules, required fields and idempotency.
3. Authorized service workflow performs bounded operation.
4. WF-20 performs privileged WooCommerce calls.
5. Result is verified.
6. WF-16 renders only verified facts.
7. WF-17 records safe audit events.

No downstream workflow may reinterpret an unauthorized action as authorized.

## Freshness
Checkout and order creation require fresh live validation immediately before mutation. Validate current cart, price, inventory, promotion and expected total.

## Failure handling
- Authorization unavailable → fail closed.
- Identity verification unavailable → do not expose protected data or execute sensitive actions.
- WooCommerce timeout after a write → do not blindly retry; reconcile by idempotency/correlation and query authoritative state.
- Verification unavailable after mutation → do not claim success; reconcile.
- Human ownership active → stop conflicting automation.

## State
Canonical state is deterministic and persisted outside the LLM. LLM may suggest intent/sales stage/next step only.

## Context
LLM receives only bounded history, verified state, authorized capabilities, approved KB facts, verified commerce results, language/script context and escalation status.
