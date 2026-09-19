# WF-20 v2 Test Matrix

## Native integration
1. Woo credential authenticates
2. get product succeeds
3. get products bounded list succeeds
4. get order succeeds for authorized scope
5. create COD order succeeds in staging
6. update order status only when explicitly authorized

## Authorization
7. no WF-10 authorization → no mutation
8. anonymous customer → no order creation
9. invalid identity → no order creation
10. LLM cannot select arbitrary operation

## COD
11. payment method is COD
12. set_paid remains false
13. customer-facing output never says paid
14. payment credentials never accepted

## Idempotency
15. duplicate idempotency key does not create duplicate order
16. timeout enters awaiting_verification
17. reconciliation finds already-created order
18. verified order stored against idempotency key

## Verification
19. line-item mismatch → fail closed
20. total mismatch → fail closed
21. currency mismatch → fail closed
22. payment method mismatch → fail closed
23. unexpected paid flag → fail closed

## Trigger
24. order.created received
25. order.updated received
26. product.updated received
27. trigger event cannot authorize an action

## Error handling
28. 401/403 → safe internal error
29. 404 → safe not-found
30. 5xx → safe retryable error
31. timeout → no success claim
32. raw Woo error not sent to Messenger
