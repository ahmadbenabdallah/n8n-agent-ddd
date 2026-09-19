# WF-13 Promotion Service Specification

## Responsibilities
WF-13:
- validate coupon/promotion codes;
- check configured promotion rules;
- evaluate product/category/customer/cart constraints using authoritative sources;
- normalize promotion results;
- provide promotion context to checkout;
- prevent stale or invented discounts;
- expose only the minimum required promotion result.

## Non-responsibilities
WF-13 does not:
- authorize customer actions;
- establish identity;
- create orders;
- process payment;
- arbitrarily modify carts;
- choose final checkout totals;
- expose WooCommerce credentials;
- accept arbitrary API endpoints from the LLM.

WF-10 is the authorization boundary.
WF-20 is the privileged WooCommerce boundary.
WF-14/commerce is authoritative for the final checkout total.
