# Requirements

- n8n
- WF-10 Action Validator
- WF-12 Cart Service
- WF-13 Promotion Service
- trusted customer identity
- live cart/price/stock/promotion validation
- payment-method configuration
- commerce checkout/order adapter
- durable idempotency store

## Required live validation response

checkout_context.live_validation_result:
{
  "verified": true,
  "cart_version": "...",
  "price_current": true,
  "stock_current": true,
  "promotion_current": true
}

For checkout operations, all relevant mutable facts must be current.

## Payment boundary
This workflow accepts a payment-method identifier such as `cod`, `card`, `bank_transfer`, etc. It must never accept or store card number, CVV, OTP, PIN or payment authentication secrets.
