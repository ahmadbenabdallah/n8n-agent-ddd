# Definition of Done — WF-16 v4

WF-16 is production-ready only when:

1. No LLM output can directly send a customer message without validation.
2. No customer-visible consequential claim lacks a verified source fact.
3. No payment/order claim conflates distinct states.
4. Human ownership blocks autonomous normal responses/actions.
5. Unknown execution is rendered as reconciliation, not success/failure.
6. Public-channel privacy controls are enforced.
7. Language/script policy is enforced after generation.
8. Response delivery is idempotent.
9. Delivery retry cannot replay commerce actions.
10. Sensitive values are excluded from logs and outputs.
11. Red-team tests pass.
12. E2E tests pass.
13. WF-17 receives structured audit events.
14. Rollback/versioning is documented.
15. The renderer remains a rendering boundary, not an authorization boundary.
