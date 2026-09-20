# Production Gate

- [ ] migration applied
- [ ] RLS reviewed
- [ ] audit writer role least privilege
- [ ] event_id uniqueness verified
- [ ] duplicate event does not duplicate ledger record
- [ ] redaction runs before persistence
- [ ] secrets/tokens/payment data cannot persist
- [ ] unnecessary PII is removed
- [ ] source IDs/versions preserved where available
- [ ] security events queryable by operations
- [ ] analytics are aggregated/minimally identifying
- [ ] retention period defined
- [ ] deletion/anonymization procedure defined
- [ ] audit system cannot authorize actions
- [ ] async failure handling tested
