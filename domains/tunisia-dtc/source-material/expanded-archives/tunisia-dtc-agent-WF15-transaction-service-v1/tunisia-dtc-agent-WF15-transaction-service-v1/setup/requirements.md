# Requirements

- n8n
- WF-10 Action Validator
- WF-14 Checkout Service
- trusted checkout result
- final live transaction revalidation
- commerce/order system
- payment service provider if card/online payment is used
- durable idempotency ledger

## Adapter responsibilities

The transaction adapter must:
- authenticate server-side
- validate checkout/cart ownership
- atomically prevent duplicate transactions
- validate amount/currency
- enforce final stock and pricing
- call PSP where applicable
- return stable transaction/order IDs
- return a deterministic status
- support idempotency
- never expose payment secrets

## Payment security

Never pass raw PAN, CVV, OTP, PIN or payment password through n8n transaction input. Prefer hosted checkout/tokenized PSP flows.
