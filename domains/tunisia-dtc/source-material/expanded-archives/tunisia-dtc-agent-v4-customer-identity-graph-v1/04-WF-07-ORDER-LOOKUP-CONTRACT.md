# WF-07 Order Lookup Contract

## Principle
**Order discovery ≠ order authorization.**

A bounded lookup may use an approved identifier such as a phone number to find candidate orders. The application must then verify the relationship before protected data is exposed.

## Candidate result
```json
{
  "match_status": "candidate",
  "candidate_count": 1,
  "candidate_refs": ["opaque_order_ref"],
  "verification_required": true
}
```

Do not return full order details, addresses, unrelated orders, internal notes, fraud data, or payment credentials.

## Multiple matches
Return an ambiguous result without exposing candidate order details.

## Verified result
```json
{
  "match_status": "verified",
  "commerce_customer_id": "wc_123",
  "order_scope": {
    "order_id": "10582",
    "permissions": ["read_status","read_shipping"]
  }
}
```

Persist the relationship only after application verification.

Final order-status responses must fetch current WooCommerce state through WF-20. The stored scope authorizes access; it is not the source of current order status.
