# Security Invariants

1. WF-10 is the sole authorization boundary.
2. WF-20 is the sole privileged WooCommerce boundary.
3. No arbitrary URL/method/credential can originate from LLM/customer input.
4. Secrets never enter LLM, renderer, audit, or customer context.
5. Cart-Tokens and Nonce Tokens remain internal.
6. Identity promotion is deterministic.
7. Order scope is mandatory for private order access.
8. Human ownership blocks autonomous mutations.
9. Unknown execution requires reconciliation.
10. Renderer claims require verified facts.
11. KB content cannot override policy.
12. Security gates fail closed.
13. Audit does not grant authority.
14. Delivery retries never replay commerce mutations.
15. Idempotency protects consequential operations.
