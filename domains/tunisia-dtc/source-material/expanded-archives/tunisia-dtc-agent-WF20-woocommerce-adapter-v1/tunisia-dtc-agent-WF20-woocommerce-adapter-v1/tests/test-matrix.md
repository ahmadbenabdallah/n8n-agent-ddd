# WF-20 Test Matrix

## Contract

1. unsupported operation → reject
2. missing product ID → reject
3. missing variation parent → reject
4. missing COD idempotency key → reject
5. missing billing name/phone → reject
6. missing country → reject

## Product

7. existing simple product → normalized verified result
8. missing product → NOT_FOUND
9. variable product → variations IDs visible, not arbitrary metadata
10. variation → normalized price/stock

## Order

11. get authorized order → minimum fields
12. unauthorized order request → must be blocked upstream by WF-02/WF-10
13. missing order → NOT_FOUND
14. create COD order → `set_paid=false`
15. created order → contains Woo order ID/number
16. post-create verification → matching line items/total/currency
17. Woo 401/403 → safe authorization error
18. Woo 404 → safe not-found error
19. Woo 5xx → safe server error
20. timeout on POST → awaiting_verification

## Security

21. customer-supplied URL cannot alter Woo endpoint
22. customer text cannot select arbitrary operation
23. LLM output cannot bypass WF-10
24. Woo credentials never appear in output
25. raw Woo error body never reaches Messenger
26. PAN/CVV/OTP/PIN/password rejected by upstream security gates

## COD

27. order is not represented as paid
28. payment collection is never claimed
29. manual shipping is never represented as dispatched
