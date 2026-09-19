# Pricing & Promotion Engine

The LLM never owns pricing.

## Pricing
`Product/Variant → Current Price → Market/Currency Rules → Promotion Validation → Shipping/Tax if applicable → Final Result → LLM Explanation`

## Promotion validator
Validates code, dates, minimum basket, eligible SKUs, customer eligibility, stacking and usage limits.

## Rules
Never invent codes, stack unapproved promotions, expose margins or negotiate outside published policy.

## Race protection
Before checkout: re-read current price/cart. If price changed, communicate the returned current value.
