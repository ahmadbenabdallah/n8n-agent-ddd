# Checkout Boundary

WF-13 may establish that a coupon is currently valid during cart/sales interaction.

It does NOT freeze the discount.

At checkout:

WF-14
→ re-read current cart
→ revalidate product/stock
→ revalidate coupon
→ calculate/verify final totals
→ only then allow WF-15 order creation.

This prevents stale coupon eligibility, expiry and usage-limit races.
