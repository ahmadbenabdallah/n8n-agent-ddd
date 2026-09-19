# WF-15 Observability

Track:
- payment status transitions;
- pending duration;
- provider latency/errors;
- unknown/reconciliation events;
- duplicate attempts;
- payment/order state mismatches;
- escalation volume;
- COD operational payment updates.

Do not log:
- PAN;
- CVV;
- OTP/PIN;
- gateway secrets;
- authorization credentials;
- unnecessary payment metadata.

Audit safe references, status transitions and correlation IDs.
