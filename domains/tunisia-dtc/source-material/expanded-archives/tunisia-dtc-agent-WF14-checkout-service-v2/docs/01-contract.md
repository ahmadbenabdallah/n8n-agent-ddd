# Contract

Example:

```json
{
  "request_id":"req_123",
  "conversation_id":"messenger_123",
  "customer_id":"cust_123",
  "operation":"checkout_confirm",
  "confirmed":true,
  "cart_reference":"wc-session-ref",
  "coupon_code":"WELCOME10",
  "customer":{
    "first_name":"Ahmed",
    "last_name":"Example",
    "email":"customer@example.com",
    "phone":"+216..."
  },
  "shipping":{
    "address_1":"...",
    "city":"Tunis",
    "postcode":"1000"
  },
  "payment_method":"cod",
  "caller_context":{"purpose":"sales"}
}
```

Customer/shipping values must originate from the trusted conversation/identity flow and be validated before order creation.

`confirmed=true` is required for `checkout_confirm`.
