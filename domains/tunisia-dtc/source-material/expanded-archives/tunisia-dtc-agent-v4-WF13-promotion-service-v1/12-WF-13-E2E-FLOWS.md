# WF-13 E2E Flows

## Valid coupon
Customer provides code → WF-13 live-validates → valid result → WF-09 explains → no claim of application until commerce confirms.

## Invalid coupon
→ live validation → invalid reason → customer receives safe explanation.

## Product restriction
→ cart/product context → restriction fails → no discount claim.

## Customer-specific promotion
→ required identity unavailable → VERIFICATION_REQUIRED.

## Coupon applied during checkout
→ WF-10 authorizes applicable mutation
→ WF-14/WF-20 applies/validates
→ final checkout total verified
→ WF-16 renders.

## Promotion changes before checkout
→ old result becomes stale
→ WF-14 revalidates
→ final commerce result wins.
