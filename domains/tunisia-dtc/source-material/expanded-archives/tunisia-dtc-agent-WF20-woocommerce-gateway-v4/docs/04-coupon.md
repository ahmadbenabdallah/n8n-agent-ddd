# Coupon Handling

The authenticated WooCommerce REST API exposes `/wc/v3/coupons`. WF-20 uses a fixed code lookup path for `coupon_validate`. citeturn0search13turn0search1

Important: finding a coupon is not identical to proving that it is eligible for the current cart/customer.

WF-20 should evaluate returned coupon rules against:
- cart amount
- products/categories
- excluded products/categories
- sale items
- expiry
- usage limits
- per-user limits
- email restrictions

If exact eligibility cannot be safely reproduced by WF-20, the preferred transactional mechanism is applying the coupon through the Store API cart and reading the resulting cart totals. The final checkout validation must still revalidate.
