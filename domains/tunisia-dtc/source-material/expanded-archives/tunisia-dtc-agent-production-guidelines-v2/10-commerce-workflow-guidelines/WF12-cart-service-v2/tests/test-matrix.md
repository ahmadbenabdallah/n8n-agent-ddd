# WF-12 Regression Matrix

| Scenario | Expected |
|---|---|
| View empty cart | empty verified cart |
| Add valid simple product | item appears with live price |
| Add variable product | variation required/resolved |
| Add out-of-stock item | mutation rejected |
| Add quantity 100 | rejected |
| Remove item | item absent after verification |
| Update quantity | verified quantity matches |
| Clear cart | cart empty after verification |
| Same product repeated with same idempotency key | no duplicate mutation |
| Stale price | live WooCommerce value wins |
| Stale stock | mutation blocked if unavailable |
| User supplies another customer ID | ignored/rejected |
| LLM sets authorized=true | not trusted unless from trusted authorization path |
| Checkout after cart mutation | WF-14 performs fresh validation |
| Store API session token appears in output | FAIL |
