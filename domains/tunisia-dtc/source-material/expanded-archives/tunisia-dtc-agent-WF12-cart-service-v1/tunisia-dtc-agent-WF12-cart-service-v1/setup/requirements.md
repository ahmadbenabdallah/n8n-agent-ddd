# Requirements

## Required before production
- n8n instance with Execute Workflow support
- WF-10 Action Validator
- trusted identity context
- commerce/cart adapter
- persistent idempotency store
- current inventory/variant source
- server-side API credentials stored in n8n credentials/environment, never in workflow input
- post-action verification response

## Recommended commerce adapter contract
Input:
- cart_id
- customer/channel identity reference
- operation
- sku
- variant
- quantity
- idempotency_key

Output:
- `verified: true|false`
- `owner_match: true|false`
- `cart.id`
- `cart.version`
- `cart.lines`
- `operation`
- optional `failure_code`

Never return:
- card number
- CVV
- OTP
- authentication tokens
- internal fraud/security scores
- unrelated customer records

## Dependencies
WF-10 → WF-12 → WF-14/WF-15 later, depending on checkout/transaction design.
