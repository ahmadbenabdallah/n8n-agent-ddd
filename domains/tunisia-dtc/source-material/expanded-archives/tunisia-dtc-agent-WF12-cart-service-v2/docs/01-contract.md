# WF-12 Contract

Input example:

```json
{
  "request_id": "req_123",
  "conversation_id": "messenger_thread_123",
  "customer_id": "cust_456",
  "operation": "cart_add",
  "product_id": 123,
  "variation_id": 456,
  "quantity": 2,
  "caller_context": {
    "purpose": "sales",
    "authorized": true
  },
  "idempotency_key": "cart-add-123-456-2"
}
```

Rules:
- quantity is integer 0–99.
- product/variation IDs are identifiers, never free-form URLs or API paths.
- LLM-supplied price is ignored.
- stock is resolved live.
- customer identity comes from WF-02, not from natural-language text.
