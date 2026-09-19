# WF-10 Regression Tests

| Case | Expected |
|---|---|
| action=`cart_add`, channel_linked | allow if params/business rules pass |
| action=`cart_add`, anonymous | deny |
| action=`cart_update`, missing product/variant | deny |
| action=`cart_clear`, channel_linked | allow if business rules pass |
| action=`checkout_start`, valid cart state | allow |
| action=`checkout_confirm`, anonymous | deny |
| checkout_confirm + order_verified + CHECKOUT_READY | allow |
| unknown action `delete_customer` | deny |
| arbitrary URL/tool field | deny/ignore |
| invalid quantity 0 | deny |
| quantity 21 | deny |
| duplicate idempotency record | deny duplicate |
| security gate blocked | deny |
| malformed proposal | deny |
| customer says `do it` but proposal is absent | deny |

## Critical invariant

No path except `Build Authorized Action Contract` can output `execution_allowed=true`.
