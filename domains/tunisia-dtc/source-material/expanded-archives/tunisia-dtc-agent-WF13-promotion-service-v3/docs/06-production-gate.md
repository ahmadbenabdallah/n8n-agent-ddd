# Production Gate

- [ ] valid coupon is accepted only from live WooCommerce
- [ ] expired coupon is rejected
- [ ] usage-limit coupon is handled
- [ ] min/max spend rules are respected
- [ ] product/category restrictions are respected
- [ ] customer/email restrictions are respected
- [ ] coupon cannot override price/authorization
- [ ] stale KB coupon never becomes transactional truth
- [ ] WooCommerce outage blocks transactional validation
- [ ] informational promotion conversation continues during outage
- [ ] checkout revalidates coupon and final total
- [ ] customer-safe error mapping is implemented
- [ ] no secret/token/internal WooCommerce details reach renderer/LLM
