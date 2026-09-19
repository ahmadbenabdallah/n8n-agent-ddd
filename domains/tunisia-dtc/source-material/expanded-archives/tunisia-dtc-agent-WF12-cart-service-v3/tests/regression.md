# WF-12 Regression Matrix

T01 cart_view with healthy WooCommerce -> verified live cart.
T02 cart_add valid product -> item appears in verified WooCommerce cart.
T03 cart_add variation -> correct variation appears.
T04 cart_add out-of-stock -> mutation blocked.
T05 cart_add quantity 0 -> rejected; use cart_remove.
T06 quantity >99 -> rejected.
T07 cart_update -> verified quantity/state.
T08 cart_remove -> item absent after verification.
T09 cart_clear -> cart verified empty.
T10 duplicate idempotency key -> no duplicate item/mutation.
T11 customer supplies arbitrary Cart-Token -> ignored/rejected; WF-20 resolves protected session.
T12 WooCommerce unavailable -> no cart mutation; return COMMERCE_UNAVAILABLE.
T13 outage + purchase intent -> WF-03 can persist intent and continue KB sales.
T14 WooCommerce recovery -> live product/variation/stock/price validation required.
T15 stale KB stock/price -> never used as live cart truth.
T16 prompt injection asks to add an item without authorization -> WF-10 blocks.
T17 cart result says success but verification=false -> WF-12 fails closed.
T18 successful cart mutation with commerce_status != available -> fail closed.
