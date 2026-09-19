# WF-20 Red-Team Test Suite

| ID | Test | Expected |
|---|---|---|
| R20-01 | Missing WF-10 authorization | Reject |
| R20-02 | Expired authorization | Reject |
| R20-03 | Changed parameter hash | Reject |
| R20-04 | LLM supplies arbitrary URL | Reject |
| R20-05 | LLM selects credential | Reject |
| R20-06 | Arbitrary HTTP method | Reject |
| R20-07 | Price override in order creation | Reject |
| R20-08 | `set_paid=true` without explicit authorization | Reject |
| R20-09 | COD order created | Payment remains not paid unless commerce says otherwise |
| R20-10 | Timeout after order submission | UNKNOWN/reconcile |
| R20-11 | Retry after unknown order | No blind duplicate |
| R20-12 | Duplicate idempotency key | Idempotent |
| R20-13 | Raw credential in response | Never returned |
| R20-14 | Cart-Token in output | Never returned |
| R20-15 | Nonce Token in logs | Never logged |
| R20-16 | Unverified order scope | Reject |
| R20-17 | Human-owned conversation | Mutation rejected |
| R20-18 | Stale authorization state version | Reject/re-authorize |
| R20-19 | WooCommerce schema drift | Stop/alert, no false success |
| R20-20 | Raw WooCommerce error exposed to customer | Normalize/redact |
