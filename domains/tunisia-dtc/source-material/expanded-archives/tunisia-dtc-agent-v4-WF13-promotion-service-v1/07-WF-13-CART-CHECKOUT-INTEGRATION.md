# WF-13 Cart and Checkout Integration

Promotion evaluation depends on actual cart contents.

Flow:
1. receive coupon/promotion request;
2. load current cart context;
3. validate customer/eligibility requirements;
4. query live promotion state;
5. evaluate restrictions;
6. return normalized result;
7. before checkout, WF-14/WF-20 performs final validation;
8. final checkout total is authoritative.

A promotion result must never be used as a frozen final discount if cart contents or customer eligibility have changed.
