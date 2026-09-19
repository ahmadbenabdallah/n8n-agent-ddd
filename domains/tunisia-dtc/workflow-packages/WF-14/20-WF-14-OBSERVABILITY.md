# WF-14 Observability

Track:
- checkout starts;
- preflight failures by reason;
- price/stock/promotion changes;
- authorization denials;
- order creation latency;
- verification failures;
- unknown executions;
- reconciliation outcomes;
- duplicate/replay attempts;
- COD order/payment-state mismatches.

Audit must capture correlation IDs, action/authorization IDs, policy version and safe result metadata.

Never log:
- payment credentials;
- Cart-Tokens/Nonce Tokens;
- API keys;
- unnecessary PII.
