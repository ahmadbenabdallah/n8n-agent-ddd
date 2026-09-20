# Contract

Input:

```json
{
  "request_id":"req_123",
  "conversation_id":"msg_thread_123",
  "customer_id":"cust_123",
  "operation":"coupon_validate",
  "code":"WELCOME10",
  "cart": {
    "items":[{"product_id":123,"variation_id":456,"quantity":2}],
    "subtotal":"120.00"
  },
  "email":"customer@example.com"
}
```

The LLM may propose the coupon code, but not its discount, eligibility, expiry, usage count or minimum-order result.

WF-13 returns a bounded result:
- code
- eligible
- discount_type
- discount_amount
- free_shipping
- reason_code
