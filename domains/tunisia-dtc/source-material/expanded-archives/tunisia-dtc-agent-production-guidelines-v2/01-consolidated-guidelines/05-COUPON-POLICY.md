# Coupon Policy

A coupon appearing in the KB is not automatically a valid transaction.

## Flow

LLM proposes code
→ WF-13 validates contract
→ WF-20 validates against WooCommerce
→ current cart/customer rules are evaluated
→ checkout revalidates
→ transaction preflight revalidates again

## Never trust from LLM

- eligible=true
- discount amount
- discount percentage
- usage count
- expiry
- minimum order
- customer restriction

## Strong validation

When exact coupon-rule reproduction is complex, validate by applying the coupon through the current WooCommerce Store API cart and reading the resulting totals rather than treating a coupon lookup as sufficient proof of the final discount.
