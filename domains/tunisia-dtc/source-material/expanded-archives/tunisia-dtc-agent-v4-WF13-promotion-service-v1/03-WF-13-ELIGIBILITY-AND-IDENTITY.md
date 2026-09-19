# WF-13 Eligibility and Identity

Promotion eligibility can depend on customer/cart context.

WF-13 may consume:
- permitted customer identity context;
- commerce customer identity;
- active cart;
- product/category data;
- promotion configuration.

WF-13 cannot promote identity or infer eligibility from a customer claim alone.

If a promotion is customer-specific and the required identity is unavailable:
`VERIFICATION_REQUIRED`

Never expose another customer's promotion eligibility or private discount.
