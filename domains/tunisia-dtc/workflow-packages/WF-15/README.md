# Tunisia DTC Agent System FINAL v4 — WF-15 Transaction & Payment Service

WF-15 owns transaction/payment-state orchestration and verification.

Core invariant:
LLM proposes → WF-10 authorizes → commerce/payment boundary executes → WF-15 verifies authoritative transaction state → WF-16 renders.

Critical semantic:
ORDER CREATED ≠ PAYMENT COMPLETED.

For COD, an order can exist while payment remains `not_paid`.
WF-15 never invents payment success and never treats an order number as proof of payment.
