# Definition of Done — WF-20 v4

WF-20 is production-ready only when:

1. It is the only privileged WooCommerce integration boundary.
2. Every consequential operation requires valid WF-10 authorization.
3. Authorization is bound to exact normalized parameters.
4. Arbitrary endpoints, methods, hosts and credentials are impossible.
5. WooCommerce credentials never enter LLM/customer/audit context.
6. Cart-Tokens and Nonce Tokens remain internal.
7. Product/order/coupon responses are normalized and field-filtered.
8. Consequential operations have post-action verification.
9. Timeout after submission becomes UNKNOWN and enters reconciliation.
10. Idempotency prevents duplicate commerce mutations.
11. COD order creation is not treated as payment.
12. Human-owned/PAUSED conversations cannot perform normal mutations.
13. Schema drift fails safely.
14. Errors are normalized and do not leak internals.
15. WF-17 receives structured audit events.
16. WF-19 can monitor gateway health.
17. Red-team and E2E suites pass.
18. Rollback and DR are tested.
