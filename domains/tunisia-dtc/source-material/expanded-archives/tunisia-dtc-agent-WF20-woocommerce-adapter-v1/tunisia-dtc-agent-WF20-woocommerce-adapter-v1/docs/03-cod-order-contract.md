# COD Order Contract

## Required

- authorized identity
- verified customer data
- non-empty line items
- current price/stock validation
- idempotency key
- COD payment method
- final order creation response
- post-creation order verification

## Prohibited

- card number
- CVV
- OTP
- PIN
- password
- arbitrary payment method chosen by the LLM
- arbitrary WooCommerce endpoint
- customer-supplied callback URL

## Success semantics

`success=true` only means the adapter has a confirmed WooCommerce order resource.

It does NOT mean:
- payment collected
- delivery scheduled
- shipment dispatched
- customer identity independently verified beyond the upstream identity contract

## Manual shipping

Shipping remains manual in v1. Do not generate a delivery ETA unless a verified policy/tool provides it.
