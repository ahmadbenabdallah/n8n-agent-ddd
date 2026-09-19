# Production Invariants

1. LLM never directly executes tools.
2. WF-10 is the sole authorization boundary.
3. WF-20 is the sole privileged WooCommerce boundary.
4. WF-16 renders verified facts only.
5. WF-17 never authorizes.
6. Dynamic commerce facts come from live commerce.
7. Consequential writes require identity/scope, authorization and idempotency.
8. Checkout/order mutation requires fresh preflight.
9. Ambiguous writes require reconciliation, not blind retry.
10. COD order creation is not payment.
11. Secrets never enter LLM/customer/log contexts.
12. Human ownership blocks conflicting automation.
13. Public channels do not expose private data.
14. Customer language/script is validated before delivery.
15. Failure of security/authorization/verification is fail-closed for consequential actions.
