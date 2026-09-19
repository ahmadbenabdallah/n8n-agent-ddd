# Master Implementation Checklist

## Architecture
- [ ] WF-00–20 deployed/versioned
- [ ] dependency matrix approved
- [ ] trust boundaries documented

## Security
- [ ] WF-10 sole authorization
- [ ] WF-20 sole WooCommerce boundary
- [ ] secrets isolated
- [ ] webhook signatures validated
- [ ] rate limiting
- [ ] idempotency
- [ ] RLS
- [ ] prompt injection controls
- [ ] KB poisoning controls

## Identity
- [ ] Messenger PSID link
- [ ] commerce match
- [ ] order verification
- [ ] order scope lifecycle
- [ ] conflict handling

## Human
- [ ] case creation
- [ ] assignment
- [ ] ownership
- [ ] pause
- [ ] explicit release
- [ ] race protection

## Commerce
- [ ] live price
- [ ] live stock
- [ ] promotion validation
- [ ] checkout preflight
- [ ] COD semantics
- [ ] payment state
- [ ] timeout reconciliation
- [ ] post-action verification

## Output
- [ ] fact-bound rendering
- [ ] privacy filter
- [ ] language/script validator
- [ ] dynamic acknowledgements
- [ ] deterministic fallbacks
- [ ] delivery idempotency

## Operations
- [ ] health checks
- [ ] alerts
- [ ] workflow drift
- [ ] dead-letter handling
- [ ] reconciliation monitoring
- [ ] backup/restore
- [ ] rollback
- [ ] incident runbooks

## Testing
- [ ] unit tests
- [ ] integration tests
- [ ] architecture tests
- [ ] red-team
- [ ] E2E
- [ ] load tests
- [ ] failure injection
