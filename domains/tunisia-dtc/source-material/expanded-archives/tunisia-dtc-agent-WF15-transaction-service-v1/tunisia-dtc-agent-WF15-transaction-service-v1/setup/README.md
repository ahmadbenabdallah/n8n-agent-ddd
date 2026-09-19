# WF-15 — Transaction Service v1

Final transactional execution boundary for creating/authorizing/capturing an order/payment transaction after checkout has been validated.

## Principle

`WF-10 authorization → WF-14 checkout → WF-15 transaction adapter → verification`

The LLM never executes payment or order operations.

## Supported boundary

- checkout confirmation
- transaction creation
- payment-method validation
- final price/stock/promotion revalidation
- idempotency
- commerce/PSP adapter request
- post-transaction verification

The workflow itself does not store card data and does not accept OTP/CVV/PIN/passwords.

## Critical success rule

A customer-facing "payment/order successful" response requires verified adapter output. Missing, timed-out, ambiguous, or unverified results are never treated as success.
