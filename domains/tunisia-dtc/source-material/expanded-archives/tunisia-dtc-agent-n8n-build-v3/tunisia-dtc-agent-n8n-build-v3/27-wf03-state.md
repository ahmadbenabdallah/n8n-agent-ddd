# WF-03 — Conversation State

## Nodes

1. `DB — Load Conversation`
2. `IF — Existing?`
3. `DB — Create Conversation`
4. `DB — Load Preferences`
5. `RETURN — State`

## Canonical state

```json
{
  "conversation_id": "conv_123",
  "language": "fr-TN",
  "intent": "product_discovery",
  "sales_stage": "DISCOVERY",
  "preferences": {
    "category": null,
    "budget": null,
    "size": null,
    "color": null,
    "use_case": null
  },
  "cart_id": null,
  "order_id": null,
  "handoff": false
}
```

LLM-suggested state changes are applied only after deterministic validation.
