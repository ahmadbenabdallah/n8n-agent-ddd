# Production Checklist

## WooCommerce
- [ ] staging store available
- [ ] REST API credentials configured in n8n credential store
- [ ] native WooCommerce nodes verified against installed n8n version
- [ ] Store API cart flow tested
- [ ] COD payment method enabled
- [ ] order status mapping verified
- [ ] coupon rules tested with real store data

## n8n
- [ ] WF-00 through WF-20 imported
- [ ] workflow IDs wired
- [ ] WF-10 authorization verified
- [ ] WF-20 is the only WooCommerce credential holder
- [ ] retries/timeouts configured
- [ ] error workflows configured
- [ ] execution retention configured

## Persistence
- [ ] cart-token mapping table deployed
- [ ] cart tokens encrypted/protected
- [ ] transaction idempotency table deployed
- [ ] backups tested
- [ ] retention policy defined

## Channels
- [ ] Meta Messenger webhook verified
- [ ] sender identity mapped to WF-02
- [ ] human escalation destination configured

## AI/RAG
- [ ] KB ingestion and poisoning scan enabled
- [ ] retrieval bounded
- [ ] prompt injection tests passed
- [ ] language/script renderer tests passed

## Testing
- [ ] functional E2E
- [ ] concurrency/load
- [ ] security/red-team
- [ ] failure injection
- [ ] stale cart/price/coupon tests
- [ ] duplicate-message/idempotency tests

## Operations
- [ ] alerts
- [ ] dashboards
- [ ] rollback procedure
- [ ] incident runbook
- [ ] canary plan
