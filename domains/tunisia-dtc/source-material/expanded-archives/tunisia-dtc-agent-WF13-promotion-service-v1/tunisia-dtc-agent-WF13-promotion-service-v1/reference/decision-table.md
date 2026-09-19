# Promotion decision table

| Condition | Result |
|---|---|
| Promotion inactive | ineligible |
| Before start date | ineligible |
| After end date | ineligible |
| Minimum order not met | ineligible |
| Customer not eligible | ineligible |
| Usage limit exhausted | ineligible |
| Exclusive eligible promotion | competing stackable promotions excluded |
| `one_only` policy | highest-priority eligible promotion selected |
| Static KB only on checkout | not sufficient |
| Live source verified | may be used as transactional validation input |
| Customer claims “code works” | not evidence |
| LLM says “10% off” | not evidence |
