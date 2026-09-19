# WF-13 WF-10 Authorization Boundary

Read-only promotion validation can be invoked through an approved service path.

Any cart/checkout mutation involving a promotion requires WF-10 authorization.

Examples:
- promotion_validate → WF-13 validation.
- applying/removing a coupon from cart → WF-10 authorization → appropriate cart/checkout service.
- checkout_confirm with coupon → WF-10 validates action and WF-14 revalidates promotion.

WF-13 must never treat a promotion result as authorization.
