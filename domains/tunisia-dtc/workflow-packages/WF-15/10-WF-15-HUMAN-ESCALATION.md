# WF-15 Payment Disputes and Human Escalation

Payment disputes, chargebacks, suspected unauthorized transactions and unresolved payment failures are mandatory escalation cases under WF-08.

When a human case is active:
- do not perform conflicting automated payment actions;
- do not claim resolution before authoritative confirmation;
- do not expose internal case IDs;
- use safe acknowledgement only when permitted.

Payment dispute handling must preserve the existing human ownership lifecycle:
`ACTIVE → HUMAN_REQUESTED → HUMAN_ASSIGNED → HUMAN_IN_PROGRESS → RESOLVED → CLOSED`.
