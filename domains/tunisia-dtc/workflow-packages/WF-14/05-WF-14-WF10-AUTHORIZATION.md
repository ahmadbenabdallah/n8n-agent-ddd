# WF-14 WF-10 Authorization

`checkout_confirm` is a consequential mutation and requires WF-10 authorization.

Authorization must be bound to:
- exact cart/checkout context;
- customer identity requirements;
- payment method;
- shipping method;
- relevant state version;
- idempotency key;
- applicable normalized parameters.

WF-14 must recheck authorization immediately before order creation.

If cart, identity, ownership, promotion, price, stock or checkout state changed materially:
→ authorization is stale
→ do not create order
→ revalidate/re-authorize.
