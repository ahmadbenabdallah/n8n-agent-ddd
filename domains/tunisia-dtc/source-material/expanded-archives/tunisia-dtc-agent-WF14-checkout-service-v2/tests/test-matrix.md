# WF-14 Regression Matrix

| Scenario | Expected |
|---|---|
| checkout_start valid COD | live validation requested |
| checkout_confirm without confirmation | rejected |
| card payment supplied | rejected |
| missing cart reference | rejected |
| product price changed | checkout not ready |
| product out of stock | checkout not ready |
| variation unavailable | checkout not ready |
| coupon expired | checkout not ready |
| coupon usage exhausted | checkout not ready |
| cart changed since WF-12 | checkout not ready / refreshed |
| customer identity mismatch | rejected |
| totals cannot be verified | rejected |
| valid checkout | verified snapshot, NOT order_created |
| WF-15 receives snapshot | performs fresh validation |
| checkout snapshot reused long after creation | WF-15 revalidates |
