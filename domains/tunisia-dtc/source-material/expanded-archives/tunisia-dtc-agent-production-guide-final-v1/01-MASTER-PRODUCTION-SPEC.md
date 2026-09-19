# Master Production Specification

## 1. Non-negotiable architecture

The control plane is n8n. The application/database owns state and authorization. WooCommerce owns live commerce truth. The LLM only proposes structured reasoning.

Required sequence:

Inbound
→ normalize
→ idempotency
→ security gate
→ identity
→ conversation state
→ intent
→ retrieval / bounded tools
→ LLM reasoning
→ structured output
→ WF-10 authorization
→ authorized execution
→ post-action verification
→ WF-16 rendering
→ WF-17 audit

## 2. Hard boundaries

### WF-10 — authorization
Only WF-10 may establish `execution_allowed=true`.

The LLM cannot:
- execute tools directly
- grant itself capabilities
- select arbitrary endpoints
- access credentials
- set final price
- invent stock
- authorize discounts
- mark payment as successful
- change identity level
- bypass order verification
- bypass confirmation requirements

### WF-20 — privileged commerce
WF-20 is the only workflow allowed to hold/use WooCommerce credentials and perform privileged WooCommerce calls.

### WF-16 — customer-facing boundary
Only verified results and approved response facts may reach Messenger.

### WF-17 — audit
Audit is append-oriented and redacted. It is never an authorization source.

## 3. Source-of-truth policy

| Fact | Authoritative source |
|---|---|
| Product description / stable attributes | Approved KB and/or WooCommerce |
| Current stock | WooCommerce |
| Current price | WooCommerce |
| Current cart | WooCommerce Store API |
| Coupon validity/applicability | WooCommerce |
| Checkout total | WooCommerce / checkout validation |
| Order status | WooCommerce |
| Payment status | WooCommerce/payment system |
| Customer identity mapping | Supabase |
| Conversation state | Supabase |
| Purchase intent during outage | Supabase |
| Audit history | Supabase audit ledger |
| Human escalation state | Supabase / configured support destination |

KB must never be treated as authority for live stock, current price, order status, payment status, or checkout totals.

## 4. COD semantics

Creating a COD order does not mean payment succeeded.

Required representation:
- `order_created=true`
- `payment_method=cod`
- `payment_status=not_paid`

Never tell the customer that COD is paid.

## 5. Identity

Identity levels:
- 0 Anonymous
- 1 Channel-linked
- 2 Order-verified
- 3 High-assurance

A customer claim, name, phone number, order number, or conversation history is not automatically proof of order ownership. Verification must be application-controlled.

Never request passwords, OTPs, PINs, PAN/card numbers, CVV, API keys, or WooCommerce secrets.

## 6. Language and script

Language and script are separate state fields.

Example:
```json
{
  "language": "tn",
  "script": "latin",
  "register": "casual",
  "mixed_languages": ["tn", "fr"]
}
```

If the customer writes Tunisian Arabic/Arabizi in Latin script, the customer-facing response must not contain Arabic Unicode unless explicitly requested or required for a legitimate quote.

KB language does not dictate customer response language.

## 7. Outage behavior

Commerce outage:
- do not invent live price/stock/order status
- do not mutate cart/order
- preserve customer profile, conversation context and purchase intent
- continue stable KB-based sales/support conversation
- resume with live validation after recovery

Database outage affecting authorization/idempotency:
- fail closed for commerce mutations
- do not create orders without reliable idempotency and authorization state

LLM outage:
- use deterministic templates for supported operational responses where possible
- do not silently bypass authorization

## 8. Idempotency

Every commerce mutation requires a stable action ID.

For order creation, if a request times out after the remote call, retry with the same action ID and reconcile before creating another order.

Idempotency record:
`customer_id + action_id + operation`

Never create a second order merely because the first response was lost.

## 9. Stale-state / TOCTOU protection

Checkout snapshots are not authorization to create an order.

WF-15 must perform a fresh preflight immediately before order creation.

Validate again:
- product/variation
- stock/purchasability
- price
- coupon
- shipping/checkout constraints
- total
- COD
- customer/order fields

## 10. Production invariants

1. No unauthorized commerce mutation.
2. No duplicate order for the same action.
3. No payment-success claim for COD.
4. No customer-visible secret/token.
5. No cross-customer order disclosure.
6. No live commerce claim from stale KB.
7. No arbitrary tool/API invocation.
8. No Arabic Unicode leakage when Latin-script output is required.
9. No audit record containing raw secrets/payment credentials.
10. Every successful mutation has post-action verification.
