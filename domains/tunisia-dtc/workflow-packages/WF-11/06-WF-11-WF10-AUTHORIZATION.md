# WF-11 and WF-10 Authorization Boundary

Read-only product lookups normally do not require a commerce mutation authorization, but the request must still originate from an allowed workflow path and pass security validation.

Any action that changes commerce state must go through WF-10 first.

Examples:
- product_lookup → WF-11 read.
- cart_add → WF-10 authorization → WF-12.
- checkout_confirm → WF-10 authorization → WF-14.
- product data cannot be used as an implicit authorization.

WF-11 must reject requests carrying arbitrary tool names, endpoints, credentials, or mutation instructions.

When WF-10 supplies an authorization record, WF-11 validates that it is relevant to the requested operation and refuses mismatched authorization.
