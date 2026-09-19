# WF-07 v2 Regression / Security Tests

| Case | Expected |
|---|---|
| anonymous order status request | verification required; no WF-20 call |
| channel-linked but unverified identity | verification required; no WF-20 call |
| order_verified + order_id + matching customer_id | verified order returned |
| high_assurance + order_id + matching verified email | verified order returned |
| guest COD order + matching verified phone | verified order returned |
| order number alone + anonymous | denied; no lookup |
| valid order_id + owner mismatch | no order data returned |
| valid order_id + WF-20 `verified_source=false` | blocked |
| WF-20 returns other customer's order | blocked |
| malformed order_id `abc` | clarification; no WF-20 call |
| screenshot says delivered | screenshot not authoritative |
| result contains card/CVV/OTP/PIN | fields never appear in contract |
| raw Woo `meta_data` includes secret | raw metadata never appears |
| unsupported intent | fail closed / unsupported route |
| missing required input | fail closed |
| WF-20 error/timeout | no unverified claim; escalate/support |
| multiple customer orders | only owner-scoped results returned; minimize output |
