# WF-13 Live Validation and Freshness

Promotion validity is dynamic.

Before a promotion is presented as currently valid for purchase, validate against the authoritative live source.

A cached result may support general information but cannot authorize a consequential checkout.

Revalidate when:
- coupon code is applied;
- cart contents change;
- customer identity changes;
- product/category restrictions change;
- checkout begins;
- a previously validated promotion becomes stale.

If validation cannot be confirmed:
`PROMOTION_UNAVAILABLE` or `REVALIDATION_REQUIRED`.

Never claim “10% off” merely because a KB document says so.
