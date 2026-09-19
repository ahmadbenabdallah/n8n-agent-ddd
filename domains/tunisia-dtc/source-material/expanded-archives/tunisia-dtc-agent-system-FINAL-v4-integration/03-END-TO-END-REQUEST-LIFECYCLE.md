# End-to-End Request Lifecycle

1. Messenger sends inbound event.
2. WF-00 normalizes and deduplicates.
3. WF-01 performs security checks.
4. WF-02 resolves identity and order scope.
5. WF-03 loads canonical state.
6. WF-04 resolves intent.
7. WF-05/WF-06 orchestrates domain flow.
8. WF-09 proposes structured reasoning/actions.
9. WF-10 validates authorization.
10. Authorized actions enter the relevant service.
11. Service calls WF-20 where WooCommerce is required.
12. WF-20 executes and verifies against WooCommerce.
13. Service updates deterministic state.
14. WF-16 renders only verified facts.
15. Messenger receives the response.
16. WF-17 records the lifecycle.
17. WF-19 monitors health/reconciliation.

At any point:
- security issue → safe handling/escalation;
- identity uncertainty → verification;
- human ownership → automation paused;
- unknown commerce execution → reconciliation;
- invalid authorization → no execution.
