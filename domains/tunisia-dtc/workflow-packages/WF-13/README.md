# Tunisia DTC Agent System FINAL v4 — WF-13 Promotion Service

WF-13 owns promotion/coupon validation and promotion-service orchestration.

Core invariant:
LLM proposes → WF-10 validates/authorizes → WF-13 validates promotion/business rules → commerce executes where required → verify → WF-16 renders.

WF-13 never lets the LLM decide discount amount, eligibility, coupon validity, expiry, usage limits, or final checkout total.
WooCommerce remains authoritative for live coupon/product/cart/checkout state.
