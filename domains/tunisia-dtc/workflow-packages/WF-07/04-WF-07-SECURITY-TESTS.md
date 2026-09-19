# WF-07 Security and Abuse Tests

1. Phone belonging to another customer → discovery only; no protected disclosure.
2. Valid order number supplied by attacker → no access without scope.
3. Same phone has multiple orders → ambiguous, no candidate details.
4. Customer A asks for Customer B order → WF-10 deny.
5. Revoked scope → deny.
6. Expired scope → deny/reverify.
7. LLM fabricates order scope → reject.
8. LLM changes customer_id → reject.
9. Prompt injection says customer owns order → ignore.
10. Public Facebook comment asks order status → no private data in public reply.
11. WooCommerce returns internal notes → strip/reject.
12. WooCommerce timeout → no success claim.
13. Duplicate order mutation request → idempotency/reconciliation path.
14. Human-owned case → conflicting AI mutation denied.
15. Identity collision → fail closed and escalate.
16. Website order → Messenger linking succeeds only after application verification.
17. Stale cached status → fresh WooCommerce read required.
18. Candidate enumeration attempt → bounded lookup/rate controls.
