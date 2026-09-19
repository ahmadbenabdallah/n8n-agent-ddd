# WF-14 Order Creation and Verification

## Sequence
1. validate authorized checkout request;
2. lock/recheck relevant state;
3. mandatory fresh preflight;
4. submit controlled order creation through WF-20;
5. treat response as potentially unverified;
6. retrieve/verify order;
7. compare:
   - customer/commerce identity where applicable;
   - line items;
   - quantities;
   - variation IDs;
   - prices;
   - discounts;
   - shipping;
   - total;
   - payment method;
   - order status/payment status;
8. mark `ORDER_VERIFIED` only after verification.

If execution result is unknown:
`UNKNOWN_EXECUTION → RECONCILIATION_REQUIRED`.

Never blindly create a second order after an ambiguous timeout.
