# WF-15 WF-10 Authorization

Payment/transaction operations that change state are consequential and require WF-10 authorization.

Read-only transaction status may be available through an approved protected path, but order/transaction scope is still required.

WF-15 verifies:
- authorization ID where required;
- conversation/request binding;
- transaction/order scope;
- action type;
- parameter binding;
- ownership mode;
- expiration;
- idempotency.

WF-15 cannot create its own authorization or elevate access.
