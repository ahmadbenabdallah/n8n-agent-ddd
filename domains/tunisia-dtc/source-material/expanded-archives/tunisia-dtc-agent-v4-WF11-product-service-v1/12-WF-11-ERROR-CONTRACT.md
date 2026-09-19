# WF-11 Error Contract

```json
{
  "success": false,
  "error": {
    "code": "REVALIDATION_REQUIRED",
    "message": "Current product information is required.",
    "retryable": true,
    "customer_safe": true
  },
  "correlation_id": "req_123"
}
```

Recommended codes:
`PRODUCT_NOT_FOUND`
`VARIATION_NOT_FOUND`
`INVALID_PRODUCT_REQUEST`
`INVALID_VARIATION_REQUEST`
`REVALIDATION_REQUIRED`
`COMMERCE_UNAVAILABLE`
`COMMERCE_TIMEOUT`
`COMMERCE_DATA_INVALID`
`ACCESS_DENIED`
`RATE_LIMITED`
`INTERNAL_ERROR`

Customer-facing messages are generated/rendered separately; internal error details must not leak.
