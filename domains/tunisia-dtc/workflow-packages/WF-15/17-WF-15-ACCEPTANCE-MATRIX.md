# WF-15 Acceptance Matrix

| Scenario | Expected |
|---|---|
| COD order created | payment_status=not_paid |
| Payment captured | PAID only after authoritative confirmation |
| Payment pending | PENDING |
| Payment failed | FAILED |
| Customer claims payment without evidence | query authoritative source |
| Missing order scope | ORDER_SCOPE_REQUIRED |
| Payment dispute | HUMAN_REQUIRED / WF-08 |
| Duplicate operation | idempotent/reconciled |
| Provider timeout | UNKNOWN → reconciliation |
| Card/CVV/OTP request | rejected |
| LLM says paid | ignored without authoritative evidence |
