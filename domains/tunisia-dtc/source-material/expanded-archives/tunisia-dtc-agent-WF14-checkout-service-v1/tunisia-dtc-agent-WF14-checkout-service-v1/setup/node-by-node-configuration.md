# Node-by-node configuration

1. **Execute Workflow Trigger** — internal only.
2. **Validate Checkout Contract** — requires authorized checkout action, `execution_allowed=true`, and `order_verified`/`high_assurance`.
3. **Checkout Input Valid?** — fail closed.
4. **Reject Invalid Checkout Request** — safe rejection.
5. **Load and Snapshot Cart** — captures cart ID/version/lines/subtotal/currency.
6. **Cart Ready?** — requires a non-empty cart.
7. **Reject Invalid Cart** — stop.
8. **Validate Checkout Data** — checks required shipping fields and payment-method identifier.
9. **Checkout Data Complete?** — routes missing fields.
10. **Request Missing Checkout Data** — returns only required field names.
11. **Build Checkout Snapshot** — freezes cart version, price/promotion version and checkout inputs.
12. **Live Price Stock Promotion Preflight** — requires trusted live validation.
13. **Preflight Valid?** — stale state cannot proceed.
14. **Stop on Stale Checkout** — customer must revalidate.
15. **Checkout Idempotency Guard** — prevents duplicate checkout confirmation.
16. **Duplicate Checkout?** — stops duplicate.
17. **Reject Duplicate Checkout** — no second commerce call.
18. **Build Commerce Checkout Request** — adapter boundary.
19. **Post-Action Checkout Verification** — requires verified owner, cart version and price.
20. **Build Checkout Service Contract** — sanitized final output.

## Adapter placement
Connect the commerce checkout adapter after `Build Commerce Checkout Request`. It may be an HTTP Request node, native connector, or Execute Workflow call. It must receive only the normalized request.
