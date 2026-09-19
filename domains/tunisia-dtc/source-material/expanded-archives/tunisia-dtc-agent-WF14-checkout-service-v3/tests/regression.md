# WF-14 Regression Matrix

T01 Healthy cart -> verified checkout snapshot.
T02 Empty cart -> checkout blocked.
T03 Product removed after cart creation -> checkout blocked.
T04 Stock changed after cart creation -> checkout reflects current state or blocks.
T05 Price changed after cart creation -> stale total rejected.
T06 Coupon becomes invalid -> checkout blocked/revalidated.
T07 Coupon discount changes -> current total wins.
T08 Shipping rule changes -> current shipping total wins.
T09 Currency mismatch -> checkout blocked.
T10 Customer tries to submit their own total -> ignored/rejected.
T11 LLM proposes arbitrary discount -> rejected.
T12 WooCommerce outage -> no checkout snapshot.
T13 Snapshot says order_created=true -> fail closed.
T14 COD checkout -> payment_status remains not_paid until an order exists.
T15 Checkout snapshot followed by delay -> WF-15 must fresh-preflight.
T16 Cart-token supplied by customer -> not trusted.
T17 Prompt injection in product metadata -> cannot alter checkout rules.
T18 Success without verified=true -> fail closed.
T19 Checkout succeeds while commerce_status != available -> fail closed.
T20 Customer says "ok" without an unambiguous preceding confirmation context -> do not create order.
