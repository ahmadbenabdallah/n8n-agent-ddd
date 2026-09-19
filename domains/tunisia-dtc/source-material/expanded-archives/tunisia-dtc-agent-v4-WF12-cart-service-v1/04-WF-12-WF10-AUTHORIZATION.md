# WF-12 WF-10 Authorization Contract

Every mutation must contain a valid, non-expired WF-10 authorization record.

WF-12 verifies:
- authorization ID;
- request/conversation binding;
- action type;
- normalized parameter binding;
- relevant state version;
- identity requirements;
- ownership mode;
- expiration;
- idempotency key.

If any binding fails:
`ACCESS_DENIED` / `AUTHORIZATION_INVALID`.

WF-12 must not reinterpret an authorization into a different mutation.

Example:
An authorization for `cart_add(product=123, variation=456, qty=1)` cannot be reused for `qty=5` or another variation.
