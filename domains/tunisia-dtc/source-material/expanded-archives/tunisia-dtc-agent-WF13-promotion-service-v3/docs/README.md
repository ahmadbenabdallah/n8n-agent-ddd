# WF-13 Promotion Service v3

Live promotion/coupon service.

## Source of truth

- WooCommerce is authoritative for coupon validity, restrictions and transactional discount behavior.
- Supabase stores customer identity/context, not coupon authorization.
- KB may explain approved promotion messaging and stable campaign terms, but cannot authorize a discount.
- WF-20 is the only privileged WooCommerce integration boundary.
- WF-10 remains the authorization boundary.

## Operations

- `coupon_validate`
- `coupon_preview`
- `promotion_info`

`promotion_info` is informational. Transactional coupon operations require live commerce.

## Important

A coupon being mentioned in KB does not mean it is currently valid.
Final checkout must revalidate the live cart and promotion immediately before checkout.
