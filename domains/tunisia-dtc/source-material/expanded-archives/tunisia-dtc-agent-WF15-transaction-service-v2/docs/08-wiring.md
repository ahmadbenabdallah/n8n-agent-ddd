# Wiring

1. Import WF-15.
2. Update/import WF-20 with `transaction_preflight`, `create_cod_order`, and `get_order`.
3. Replace both `REPLACE_WITH_WF20_WORKFLOW_ID` values.
4. Connect WF-14 verified checkout output.
5. Ensure WF-10 is the upstream authorization boundary.
6. Add durable idempotency persistence.
7. Connect WF-17 audit for failures and transaction events.
8. Connect WF-16 only after final verification.
