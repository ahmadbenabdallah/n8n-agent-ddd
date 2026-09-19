# WF-15 Payment State Model

Canonical transaction state:

`UNKNOWN`
`NOT_REQUIRED`
`PENDING`
`AUTHORIZED`
`PAID`
`FAILED`
`CANCELLED`
`REFUNDED`
`PARTIALLY_REFUNDED`
`DISPUTED`
`REQUIRES_RECONCILIATION`

The exact state exposed to customers must come from authoritative commerce/payment state.

## COD
For a newly created COD order:
`payment_status = NOT_PAID`

COD may transition later according to real operational/payment events.

Never infer:
`ORDER_CREATED → PAID`.
