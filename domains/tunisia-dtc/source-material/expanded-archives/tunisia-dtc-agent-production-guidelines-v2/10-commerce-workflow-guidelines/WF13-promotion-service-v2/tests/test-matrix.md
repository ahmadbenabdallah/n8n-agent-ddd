# WF-13 Regression Matrix

| Scenario | Expected |
|---|---|
| Valid coupon | eligible=true with WooCommerce-derived discount |
| Unknown coupon | eligible=false |
| Expired coupon | eligible=false |
| Usage limit reached | eligible=false |
| Per-user limit reached | eligible=false |
| Below minimum amount | eligible=false |
| Above maximum amount | eligible=false |
| Restricted product | eligible=false |
| Excluded product | eligible=false |
| Excluded sale item | eligible=false when rule applies |
| Restricted email | eligible=false |
| Individual-use conflict | validation reflects WooCommerce rules |
| KB says 20% but WC says 10% | WC result wins |
| LLM sends discount_amount=999 | ignored |
| LLM sends eligible=true | ignored |
| Coupon meta_data returned by WC | stripped |
| Checkout after validation | WF-14 revalidates |
