# Security Policy — Production v3

## Defense in depth
Input security → identity → least privilege → bounded retrieval → structured output → WF-10 authorization → idempotency → execution → post-action verification → audit.

## OWASP LLM/agent controls
Address prompt injection, sensitive disclosure, supply-chain risk, poisoning, improper output handling, excessive agency, prompt leakage, vector/embedding weaknesses, misinformation, unbounded consumption, tool misuse and identity/privilege abuse.

## Hard boundaries
- WF-10 is the sole authorization boundary.
- WF-20 is the sole privileged WooCommerce boundary.
- WF-16 cannot execute actions.
- WF-17 cannot authorize actions.

## Secrets
Never expose or log PAN, CVV, OTP, PIN, passwords, API keys, WooCommerce credentials, Cart-Tokens, Nonce Tokens or other secrets.

## Fail closed
If security, identity, authorization or required commerce verification is unavailable, do not perform consequential actions.

## Public channels
No private order/customer/payment details in public comments.

## Logging
Use correlation IDs, action IDs and safe error codes. Redact sensitive fields before persistence.
