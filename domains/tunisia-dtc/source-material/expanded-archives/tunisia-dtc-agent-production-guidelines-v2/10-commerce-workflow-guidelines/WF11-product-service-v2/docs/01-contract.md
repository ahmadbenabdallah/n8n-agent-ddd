# Contract

Example request:

```json
{
  "request_id": "req_123",
  "operation": "get_product",
  "caller_context": {
    "purpose": "sales",
    "actor": "agent"
  },
  "product_id": 123
}
```

For SKU lookup use `sku`. For a variation use `product_id` + `variation_id`.

`purpose` must be one of:
- product_read
- checkout_validation
- cart_validation
- sales

WF-11 never accepts an LLM-generated price or stock value as authority.
