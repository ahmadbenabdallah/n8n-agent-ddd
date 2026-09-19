# WF-13 Acceptance Matrix

| Scenario | Expected |
|---|---|
| Valid public coupon | valid structured result |
| Unknown code | PROMOTION_NOT_FOUND/INVALID |
| Expired coupon | PROMOTION_EXPIRED |
| Minimum order unmet | PROMOTION_MIN_ORDER |
| Product restriction fails | PROMOTION_PRODUCT_RESTRICTION |
| Customer restriction without identity | VERIFICATION_REQUIRED |
| KB conflicts with live state | live state wins |
| LLM invents discount | rejected/ignored |
| Coupon changes before checkout | final validation wins |
| Arbitrary WooCommerce endpoint | rejected |
| Credential in promotion request | rejected + security event |
| Commerce timeout | structured retryable error |
