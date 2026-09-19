# FINAL Production Gate

A production launch is blocked until every applicable checkbox is proven with evidence.

## Architecture
- [ ] WF-00..WF-20 installed/versioned
- [ ] Workflow dependency graph validated
- [ ] WF-10 is the sole authorization boundary
- [ ] WF-20 is the sole privileged WooCommerce boundary
- [ ] WF-16 is the sole customer-facing rendering boundary

## Security
- [ ] Secrets scan passes
- [ ] Dependency/image/security scans pass
- [ ] Prompt-injection tests pass
- [ ] Tool abuse tests pass
- [ ] Identity spoofing tests pass
- [ ] Cross-customer isolation passes
- [ ] Secret/token redaction passes
- [ ] Rate limiting passes
- [ ] Unknown WF-20 operations are rejected

## Data
- [ ] Supabase migrations applied and verified
- [ ] Idempotency schema verified
- [ ] Cart-session protection verified
- [ ] KB versioning verified
- [ ] pgvector dimension verified against deployed embedding model
- [ ] Retention policies configured
- [ ] Backup completed

## Commerce
- [ ] Product live reads verified
- [ ] Cart mutations verified
- [ ] Coupon restrictions verified
- [ ] Checkout drift tests pass
- [ ] COD order creation verified
- [ ] Post-create verification passes
- [ ] Duplicate-order recovery tested

## Channel
- [ ] Meta webhook verification passes
- [ ] Replay/duplicate event handling passes
- [ ] Messenger response formatting passes
- [ ] Latin-script Tunisian output guard passes

## Reliability
- [ ] WooCommerce outage tested
- [ ] Supabase outage tested
- [ ] OpenAI outage tested
- [ ] n8n workflow failure tested
- [ ] Timeout/retry behavior tested
- [ ] Recovery/reconciliation tested
- [ ] Alert routing tested

## Operations
- [ ] Monitoring dashboard exists
- [ ] P0/P1 alerts tested
- [ ] Runbooks available
- [ ] Rollback tested
- [ ] Restore tested
- [ ] On-call/operator ownership assigned

## Evidence
For every critical gate, store:
- test name
- timestamp
- environment
- version/commit
- result
- relevant correlation IDs
- operator approval where required

## Final rule

No “looks good” approval. Production approval requires test evidence.
