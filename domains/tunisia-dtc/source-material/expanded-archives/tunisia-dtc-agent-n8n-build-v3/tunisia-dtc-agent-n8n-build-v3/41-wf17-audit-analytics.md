# WF-17 — Audit & Analytics

## Security audit

Record:
- correlation ID;
- actor;
- action;
- authorization;
- result;
- security flags;
- tool;
- timestamp.

## Business events

- product_recommended
- product_selected
- add_to_cart
- promotion_validated
- checkout_started
- purchase_completed
- escalation_created

## Attribution

Persist `conversation_id` and `agent_assisted=true` into the commerce/analytics event where supported.

Do not infer revenue causality beyond the configured attribution model.
