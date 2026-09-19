# WF-07 ↔ WF-20 WooCommerce Contract

WF-20 is the only privileged WooCommerce integration boundary.

## Discovery

WF-07 requests a bounded lookup through WF-20.

Allowed example:
```json
{
  "operation": "find_order_candidates",
  "customer_id": "cust_uuid",
  "lookup_type": "phone",
  "lookup_ref": "server-side-ref",
  "limit": 5
}
```

WF-20 returns only minimum candidate metadata required for verification.

## Scoped read

```json
{
  "operation": "get_order",
  "order_id": "10582",
  "allowed_fields": ["status","shipping_summary"]
}
```

This request must already have a WF-10 authorization decision.

## Freshness

Every protected status response performs a fresh WooCommerce read.

Cached order data may be used for context, but not as final live truth.

## Timeout

If WooCommerce times out:
- mark result UNKNOWN/UNAVAILABLE;
- do not claim success;
- for mutations, trigger reconciliation before retry;
- for reads, return a safe unavailable state or retry according to policy.
