# Security

1. WF-10 remains the authorization boundary.
2. WF-12 does not authorize itself merely because an operation is syntactically valid.
3. WF-20 is the only privileged commerce boundary.
4. Customer-provided cart tokens are never trusted.
5. Raw Cart-Token/nonce/API credentials are never exposed to LLM or renderer.
6. Cart operations require customer identity and bounded product/quantity fields.
7. Every mutation uses an idempotency key.
8. Every successful mutation requires post-action verification.
9. WooCommerce outage blocks transactional cart operations.
10. KB cannot substitute for live cart, stock, price or availability.
11. Do not log complete customer addresses/phone numbers or commerce tokens in general audit events.
