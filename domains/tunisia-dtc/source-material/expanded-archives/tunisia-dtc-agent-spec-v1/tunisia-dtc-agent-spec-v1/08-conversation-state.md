# Conversation State

## Canonical state

``` json
{
  "conversation_id": "string",
  "channel": "whatsapp",
  "customer_id": "string|null",
  "language": "fr-TN",
  "intent": "product_discovery",
  "sales_stage": "CONSIDERING",
  "preferences": {
    "category": null,
    "budget": null,
    "size": null,
    "color": null,
    "use_case": null
  },
  "products_viewed": [],
  "products_recommended": [],
  "cart_id": null,
  "order_id": null,
  "risk_flags": [],
  "handoff": false,
  "turn_count": 0,
  "updated_at": "ISO-8601"
}
```

## State rules

-   n8n/database owns canonical state.
-   LLM can suggest state updates.
-   n8n validates state transitions.
-   State never overrides transactional systems.
-   Old state must not override new verified data.

## Memory window

Use bounded conversation history. Retrieve older information selectively
rather than injecting unlimited history.

## Repetition

After repeated near-identical customer requests: - stop repeating the
same response; - offer a human handoff.

## Conversation cap

After a configurable maximum number of automated turns, escalate with a
structured summary.
