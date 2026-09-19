# Tunisia DTC Agent System FINAL v4 — WF-14 Checkout Service

WF-14 owns checkout orchestration and the transition from a validated cart to an order-creation request.

Core invariant:
LLM proposes → WF-10 authorizes → WF-14 validates checkout → WF-20 executes commerce operation → WF-14 verifies → WF-16 renders.

For Cash on Delivery (COD), creating an order is NOT payment. A newly created COD order is `payment_status=not_paid` unless authoritative commerce state says otherwise.
