# Source of Truth Policy

## Live transactional truth: WooCommerce

Use WooCommerce for:
- product identity
- SKU
- variation
- current price
- sale price
- stock quantity/status
- purchasability
- cart contents
- current cart totals
- coupon validity/rules
- checkout state
- order state

## Knowledge Base

Use KB for:
- product descriptions
- features/specifications that are not mutable transaction facts
- usage/care
- approved positioning
- FAQs
- static campaign information

Never use KB as the final authority for:
- current price
- current stock
- final coupon eligibility
- final discount
- order status
- payment status

## Example

KB says: 99 TND.
WooCommerce says: 109 TND.

Customer-facing transactional answer: 109 TND.

KB says: in stock.
WooCommerce says: out of stock.

Cart mutation: reject as unavailable.
