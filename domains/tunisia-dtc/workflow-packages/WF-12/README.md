# Tunisia DTC Agent System FINAL v4 — WF-12 Cart Service

WF-12 owns cart orchestration and cart mutations.

Architecture:
LLM proposes → WF-10 authorizes → WF-12 executes → commerce/WF-20 verifies → WF-16 renders.

WF-12 is not an authorization boundary and cannot grant itself permission.
WooCommerce remains authoritative for live cart state and product/variation state.
