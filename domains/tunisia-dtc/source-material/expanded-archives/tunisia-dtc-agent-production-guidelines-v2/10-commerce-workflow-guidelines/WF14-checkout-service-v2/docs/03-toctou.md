# TOCTOU / Race Condition

WF-14 closes most stale-state risk but cannot guarantee inventory reservation.

Therefore:

WF-14
→ validate current state
→ customer confirmation
→ WF-15
→ revalidate again
→ create WooCommerce order
→ retrieve created order
→ verify identity, line items, totals and status

If stock/price/coupon state changes between validation and creation, WF-15 must fail safely and return a revalidation-required result.
