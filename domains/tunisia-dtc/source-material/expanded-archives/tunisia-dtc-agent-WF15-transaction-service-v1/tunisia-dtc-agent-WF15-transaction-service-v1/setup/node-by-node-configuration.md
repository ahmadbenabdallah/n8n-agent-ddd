# Node-by-node configuration

1. **Execute Workflow Trigger** — internal sub-workflow.
2. **Validate Transaction Contract** — only authorized `checkout_confirm`/`transaction_create`.
3. **Transaction Input Valid?** — fail closed.
4. **Reject Invalid Transaction Request**.
5. **Load Verified Checkout** — obtains checkout ID/cart ID/version/amount/currency.
6. **Checkout Valid?** — requires a valid checkout.
7. **Reject Invalid Checkout**.
8. **Final Live Transaction Revalidation** — validates mutable facts immediately before transaction.
9. **Live Facts Current?** — stale price/stock/promotion blocks transaction.
10. **Stop on Stale Transaction Facts**.
11. **Validate Payment Method Boundary** — opaque payment-method ID only; rejects secrets.
12. **Payment Method Valid?**.
13. **Reject Invalid Payment Boundary**.
14. **Transaction Idempotency Guard** — deterministic idempotency key.
15. **Duplicate Transaction?**.
16. **Reject Duplicate Transaction**.
17. **Build Commerce Transaction Request** — adapter boundary.
18. **Post-Transaction Verification** — verifies owner, amount, currency and transaction status.
19. **Build Transaction Service Contract** — sanitized result.

### Adapter connection

Insert an HTTP Request/native connector/Execute Workflow between `Build Commerce Transaction Request` and `Post-Transaction Verification`.

Do not expose the adapter publicly.
