# WF-05 Sales State × Intent Matrix

## Purpose

This matrix prevents generic sales handling from overriding more specific intents.

| Intent | Typical stage | WF-05 behavior | Downstream |
|---|---|---|---|
| product_discovery | BROWSING/DISCOVERY | discover need and candidate products | WF-11 |
| product_question | PRODUCT_INTEREST | answer verified facts | WF-11 |
| comparison | CONSIDERING | compare verified attributes | WF-11 |
| pricing | PRODUCT_INTEREST/CONSIDERING | retrieve current price | WF-11 |
| promotion | CONSIDERING | validate promotion | WF-13 |
| availability | PRODUCT_INTEREST | retrieve live availability | WF-11 |
| cart_view | CART_BUILDING | identify cart operation | WF-12 |
| cart_add | PRODUCT_SELECTED/CART_BUILDING | prepare add/update action | WF-12 |
| cart_remove | CART_BUILDING | prepare removal | WF-12 |
| cart_update | CART_BUILDING | prepare quantity/variant update | WF-12 |
| cart_clear | CART_BUILDING | prepare clear operation | WF-12 |
| checkout_start | CART_BUILDING | prepare fresh checkout preflight | WF-14 |
| checkout_confirm | CHECKOUT_READY | require explicit confirmation and full validation | WF-14/WF-15 |
| shipping | any | provide approved shipping facts | WF-06/KB/live service |
| payment | any | provide approved payment facts | WF-06/KB |
| order_status | POST_PURCHASE | delegate to WF-07 with scope | WF-07 |
| return_exchange | POST_PURCHASE | delegate policy/support flow | WF-06/WF-08 |
| complaint | any | determine support/escalation path | WF-06/WF-08 |
| human_request | any | stop normal sales progression and hand off | WF-08 |

## Specific-intent precedence

Use the most specific applicable intent.

Examples:

`"nheb hadha"` → product selection.

`"zidhali lel panier"` → cart_add.

`"na9esli wa7ed"` → cart_update.

`"fasakhha mel panier"` → cart_remove.

`"warini chnowa fel panier"` → cart_view.

`"nheb nchri taw"` → checkout_start/checkout_confirm depending on explicit confirmation context.

A generic `product_question` must not overwrite a more specific cart or checkout intent.

## Checkout confirmation rule

Do not interpret:
- “I’m interested”
- “looks good”
- “how much?”
- “maybe”
as purchase confirmation.

Explicit purchase confirmation must be present before a consequential checkout/order action proceeds.

## Human-owned conversation

Any intent received while a human case is actively owned must first be evaluated against the case state. A related message is routed to the human case rather than independently resolved by WF-05.
