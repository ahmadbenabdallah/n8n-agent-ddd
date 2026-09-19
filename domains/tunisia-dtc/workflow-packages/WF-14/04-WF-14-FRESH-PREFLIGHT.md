# WF-14 Mandatory Fresh Preflight

Immediately before order creation, WF-14 must revalidate all consequential commerce facts.

At minimum:
1. current cart contents;
2. product/variation purchasability;
3. current stock;
4. current item prices;
5. promotion/coupon validity and eligibility;
6. shipping availability/fee where applicable;
7. taxes/fees where applicable;
8. final checkout total;
9. required checkout fields;
10. payment method eligibility;
11. relevant identity/ownership state.

Any material change invalidates the earlier proposal/authorization as required and stops order creation until revalidated/re-authorized.

The LLM must never calculate the final checkout total.
