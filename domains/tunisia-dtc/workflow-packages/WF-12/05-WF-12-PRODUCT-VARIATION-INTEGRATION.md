# WF-12 Product / Variation Integration

WF-11 provides product and variation facts.

For `cart_add`:
1. receive canonical product/variation request;
2. validate authorization;
3. obtain current required product/variation state;
4. reject unavailable/non-purchasable variants;
5. execute the authorized mutation through WF-20;
6. retrieve/verify resulting cart;
7. return normalized cart state.

Customer request:
`Ok zidhali taille 42 lel panier.`

Must resolve actual variation 42. The system must not assume that size 42 exists.
If multiple variants match ambiguously, stop and request clarification.
