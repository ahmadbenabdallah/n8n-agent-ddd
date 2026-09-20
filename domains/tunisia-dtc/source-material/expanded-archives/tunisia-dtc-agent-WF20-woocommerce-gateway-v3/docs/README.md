# WF-20 WooCommerce Gateway v3

WF-20 is the single commerce integration boundary for the agent.

Architecture:

WF-07 / WF-11 / WF-12 / WF-13 / WF-14 / WF-15
        ↓
      WF-20
        ↓
WooCommerce Native Node / REST API / Store API
        ↓
WooCommerce

WooCommerce REST API v3 is the current recommended REST API for new integrations. It supports products, customers, coupons and orders. The Store API is the customer-facing surface for cart and checkout functionality. citeturn0search1turn0search4

The gateway deliberately uses:
- native n8n WooCommerce nodes where they fit,
- narrowly scoped HTTP Request nodes for coupon and Store API operations,
- one bounded operation contract,
- one normalization layer,
- one semantic guard.
