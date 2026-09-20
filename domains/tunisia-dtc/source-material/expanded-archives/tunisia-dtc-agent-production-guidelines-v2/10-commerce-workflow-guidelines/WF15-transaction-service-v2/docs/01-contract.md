# Transaction Contract

```json
{
  "request_id":"req_123",
  "conversation_id":"messenger_123",
  "customer_id":"cust_123",
  "operation":"create_cod_order",
  "confirmed":true,
  "payment_method":"cod",
  "cart_reference":"wc-session-ref",
  "coupon_code":"WELCOME10",
  "customer":{},
  "shipping":{},
  "idempotency_key":"order-messenger_123-abc",
  "caller_context":{
    "authorized":true,
    "purpose":"checkout"
  }
}
```

The order payload must be constructed from validated state. LLM-supplied totals, price, discount, stock and payment status are never authoritative.
