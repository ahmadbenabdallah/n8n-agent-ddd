# WF-15 Regression Matrix

| Scenario | Expected |
|---|---|
| valid confirmed COD checkout | fresh preflight then order creation |
| no confirmation | reject |
| card payment | reject |
| authorization missing | reject |
| stale WF-14 price | preflight catches |
| stock changed | preflight catches |
| coupon expired | preflight catches |
| cart changed | preflight catches |
| valid creation | WooCommerce order created |
| repeated same idempotency key | same order/result, no duplicate |
| WooCommerce create returns no ID | fail safely |
| post-create get fails | do not claim confirmation |
| created COD order | payment_status=not_paid |
| order status pending | do not call paid |
| LLM says payment captured | ignored |
| arbitrary WooCommerce endpoint | rejected |
| PAN/CVV/OTP supplied | rejected/redacted |
