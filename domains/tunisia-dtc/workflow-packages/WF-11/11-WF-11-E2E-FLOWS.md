# WF-11 E2E Flows

## Product question
Customer asks warranty/features → WF-11 returns approved stable facts → WF-09 drafts response → WF-16 renders.

## Current price
Customer asks current price → WF-11 obtains live WooCommerce fact → response may state current price with freshness.

## Availability
Customer asks if size 42 exists → WF-11 resolves variation → live availability check → structured result.

## Cart add
Customer: "Ok zidhali taille 42 lel panier."
→ WF-11 resolves product/variation and current preconditions
→ WF-10 authorizes cart mutation
→ WF-12 executes
→ WF-11 is not the mutation executor.

## Stale cache
Cached product says in stock → checkout begins later → WF-14/WF-20 revalidate live stock → cached fact cannot authorize purchase.

## WooCommerce unavailable
WF-20 fails → WF-11 returns `COMMERCE_UNAVAILABLE` → no invented product state.
