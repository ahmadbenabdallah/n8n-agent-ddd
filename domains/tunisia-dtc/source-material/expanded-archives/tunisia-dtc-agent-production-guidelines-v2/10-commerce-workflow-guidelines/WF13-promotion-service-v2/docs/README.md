# WF-13 Promotion Service v2

WF-13 is the promotion/coupon decision boundary for the agent.

WooCommerce is the transactional authority for coupon validity and the resulting discount. The Knowledge Base may explain advertised promotions, but it cannot authorize a discount.

The WC REST API exposes coupon properties including code, discount type/amount, expiry, usage limits, product/category restrictions, sale-item restrictions, minimum/maximum order amounts and email restrictions. citeturn0search0turn0search1

WF-13 is intentionally read/validate oriented. It does not create, edit or delete coupons.
