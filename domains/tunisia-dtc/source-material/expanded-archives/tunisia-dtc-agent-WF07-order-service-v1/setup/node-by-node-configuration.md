# Node-by-node configuration

1. **Execute Workflow Trigger** — invoked for an order-status request.
2. **Validate Order Input** — checks canonical upstream fields.
3. **Order Input Valid?** — fail-closed branch.
4. **Fail Closed** — blocks malformed requests.
5. **Order Status Intent?** — this workflow is deliberately narrow.
6. **Reject Unsupported Order Query** — sends other intents back to support routing.
7. **Verify Order Access** — checks trusted identity level from WF-02.
8. **Authorized Order Access?** — requires `order_verified` or `high_assurance`.
9. **Require Order Verification** — safe clarification; no transaction lookup.
10. **Minimize Order Fields** — allowlists only necessary order fields.
11. **Build Transaction Query** — creates a bounded read-only query.
12. **Verify Transaction Result** — checks verified source and owner match.
13. **Verified Result?** — fail closed on unverified data.
14. **Block Unverified Result** — escalation path.
15. **Build Verified Order Result** — strips non-allowlisted fields.
16. **Build Order Service Contract** — final contract for downstream reasoning/rendering.

## Commerce adapter

The transaction query should be sent only to an internal/approved commerce adapter. Do not pass arbitrary customer text as a URL, SQL statement, GraphQL query, or executable command.

The adapter should return:

```json
{
  "verified_source": true,
  "owner_match": true,
  "order_id": "ORD-123",
  "status": "in_transit",
  "fulfillment_status": "shipped",
  "estimated_delivery": "2026-09-18",
  "tracking_available": true,
  "tracking_url": "...",
  "items_summary": []
}
```

The exact fields depend on the commerce platform.
