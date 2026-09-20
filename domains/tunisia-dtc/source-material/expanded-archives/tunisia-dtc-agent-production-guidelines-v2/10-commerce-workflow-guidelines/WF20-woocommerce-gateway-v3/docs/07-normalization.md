# Normalization

Every successful operation returns:

```json
{
  "success": true,
  "request_id": "req_123",
  "gateway_operation": "get_product",
  "verified_gateway": true,
  "source": "woocommerce"
}
```

Then an operation-specific object:
- `product`
- `products`
- `order`
- `cart`
- `coupon_validation`
- `checkout_validation`
- `validation`

Raw upstream responses must not be forwarded directly to WF-16.
