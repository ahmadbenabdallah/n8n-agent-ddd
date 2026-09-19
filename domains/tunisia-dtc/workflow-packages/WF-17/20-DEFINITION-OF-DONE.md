# Definition of Done — WF-17 v4

WF-17 is production-ready only when:

1. Every consequential action is correlated end-to-end.
2. Audit events are append-only or correction-safe.
3. Event ingestion is idempotent.
4. Sensitive data is redacted before persistence.
5. WF-17 cannot authorize or execute commerce.
6. WF-10 remains the sole authorization boundary.
7. WF-20 remains the sole privileged WooCommerce boundary.
8. Unknown execution is preserved until reconciliation.
9. Order creation and payment are distinct in analytics.
10. Identity/order-scope transitions are auditable without proof leakage.
11. Human ownership lifecycle is fully visible.
12. LLM telemetry is useful without storing hidden prompts/secrets.
13. Audit outages use durable delivery/outbox mechanisms.
14. Security and operational alerts have runbooks.
15. Red-team and E2E suites pass.
16. Retention and least-privilege access controls are documented.
