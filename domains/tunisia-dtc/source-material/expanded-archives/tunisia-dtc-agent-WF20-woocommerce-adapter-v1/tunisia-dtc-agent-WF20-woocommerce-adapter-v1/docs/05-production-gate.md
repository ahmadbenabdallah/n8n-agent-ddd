# Production Gate

Do not connect WF-20 to live Messenger until all are true:

- [ ] Woo staging API works over HTTPS
- [ ] Dedicated REST credentials exist
- [ ] Credentials are in n8n credential store only
- [ ] Product read test passes
- [ ] Variation read test passes
- [ ] Order read authorization test passes
- [ ] COD order creation test passes
- [ ] Post-create verification passes
- [ ] Idempotency/reconciliation tested
- [ ] 401/403/404/5xx/timeouts tested
- [ ] Agent DB idempotency table exists
- [ ] Audit redaction verified
- [ ] WF-10 remains mandatory
- [ ] WF-16 success response is based only on verified output
- [ ] Manual shipping wording is approved
- [ ] Rollback procedure tested
- [ ] Production Woo API credentials are separate from staging
