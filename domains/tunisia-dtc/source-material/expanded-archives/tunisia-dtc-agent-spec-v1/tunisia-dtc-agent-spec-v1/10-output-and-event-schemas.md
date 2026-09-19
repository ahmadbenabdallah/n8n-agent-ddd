# Output & Event Schemas

## LLM response schema

``` json
{
  "response": "string",
  "language": "fr-TN",
  "intent": "product_discovery",
  "sales_stage": "DISCOVERY",
  "actions": [],
  "sources": ["product-001"],
  "requires_human": false,
  "escalation_reason": null,
  "claims_grounded": true
}
```

## Action schema

``` json
{
  "type": "SEARCH_PRODUCTS",
  "parameters": {
    "query": "hoodie",
    "filters": {}
  }
}
```

Allowed action types must come from the server-generated allowlist.

## Event envelope

``` json
{
  "event_id": "uuid",
  "event_type": "product_recommended",
  "timestamp": "ISO-8601",
  "conversation_id": "string",
  "customer_id": "string|null",
  "channel": "whatsapp",
  "agent_version": "1.0",
  "model": "model-id",
  "data": {}
}
```

## Important events

-   message_received
-   security_flagged
-   intent_detected
-   kb_retrieved
-   product_recommended
-   product_selected
-   cart_created
-   cart_item_added
-   promotion_validated
-   checkout_started
-   purchase_completed
-   order_lookup
-   escalation_created
-   human_resolved
