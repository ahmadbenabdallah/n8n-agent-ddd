# Conversation State

## Purpose

Maintain deterministic state outside the LLM.

## Suggested state

```json
{
  "conversation_id": "",
  "channel": "",
  "language": "",
  "intent": "",
  "sub_intent": "",
  "sales_stage": "",
  "identity_level": 0,
  "selected_products": [],
  "cart_id": null,
  "order_scope": null,
  "last_action_id": null,
  "turn_count": 0,
  "escalation_status": "none",
  "risk_flags": [],
  "last_updated": ""
}
```

## State ownership

Application/database owns canonical state.

LLM may suggest:
- intent
- sales stage
- next conversational step

Application validates and persists changes.

## State transitions

Transitions must be allowlisted.

Example:
- NEW → BROWSING
- BROWSING → DISCOVERY
- DISCOVERY → PRODUCT_INTEREST
- PRODUCT_INTEREST → CONSIDERING
- CONSIDERING → PRODUCT_SELECTED
- PRODUCT_SELECTED → CART_BUILDING
- CART_BUILDING → CHECKOUT_READY

Do not permit arbitrary LLM-generated state transitions.

## Turn limits

Track automated turns.

At configured threshold:
- stop repetitive automation
- offer human support or close appropriately

## Repetition guard

Detect repeated:
- same answer
- same question
- same failed action

Escalate or change strategy.

## Persistence

State should survive webhook retries and workflow restarts.

Use idempotent state writes.
