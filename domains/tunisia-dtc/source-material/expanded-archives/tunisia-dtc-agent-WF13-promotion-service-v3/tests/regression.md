# WF-13 Regression Matrix

T01 Valid coupon + eligible cart -> verified promotion result.
T02 Expired coupon -> rejected.
T03 Disabled coupon -> rejected.
T04 Minimum spend not met -> rejected.
T05 Maximum spend exceeded -> handled according to WooCommerce rule.
T06 Product restriction -> rejected when cart is ineligible.
T07 Category restriction -> rejected when cart is ineligible.
T08 Excluded product/category -> rejected.
T09 Individual-use conflict -> rejected/handled by WooCommerce.
T10 Usage limit exhausted -> rejected.
T11 Customer/email restriction -> rejected when unauthorized.
T12 KB says coupon active but WooCommerce says invalid -> WooCommerce wins.
T13 WooCommerce unavailable + coupon_validate -> no validity claim.
T14 WooCommerce unavailable + promotion_info -> KB informational response allowed.
T15 Prompt injection inside coupon code -> treated as data, never instructions.
T16 LLM proposes arbitrary discount amount -> WF-10/WF-20 rejects.
T17 Promotion success but verified=false -> fail closed.
T18 Coupon valid at conversation time but cart changes before checkout -> WF-14 revalidates.
T19 Coupon validation must not mutate coupon configuration.
