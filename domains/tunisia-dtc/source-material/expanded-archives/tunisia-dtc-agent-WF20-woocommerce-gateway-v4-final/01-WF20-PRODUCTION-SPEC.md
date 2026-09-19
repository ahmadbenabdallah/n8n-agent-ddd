# WF-20 Production Specification

## 1. Purpose

Provide a tightly controlled, observable, typed integration boundary between the agent orchestration layer and WooCommerce.

Responsibilities:
1. authenticate to WooCommerce;
2. expose allowlisted operations;
3. normalize WooCommerce responses;
4. enforce parameter schemas;
5. enforce endpoint/resource restrictions;
6. execute only WF-10-authorized operations;
7. handle bounded retries;
8. detect unknown execution;
9. perform post-action verification;
10. protect secrets;
11. maintain idempotency;
12. report structured errors;
13. expose health signals to WF-19;
14. emit audit events to WF-17.

WF-20 does not:
- decide whether a customer is authorized;
- decide whether an action is commercially allowed;
- infer customer intent;
- trust LLM instructions;
- accept arbitrary URLs/endpoints;
- expose credentials to upstream workflows.

## 2. Integration boundary

Preferred authenticated administrative operations use the WooCommerce REST API v3.

Customer-facing Store API capabilities may be used only where explicitly required for controlled cart/checkout/session behavior and must remain isolated from administrative REST credentials.

No upstream workflow may provide an arbitrary URL, HTTP method, header, or credential reference.

## 3. Operation families

Allowlist examples:

### Products
- get product
- list/search products
- get variations

### Orders
- get order
- create order
- controlled order update where explicitly authorized
- read order status

### Customers
- controlled customer lookup/update where explicitly required

### Coupons
- controlled coupon lookup/validation

### Store/cart/checkout
Only explicitly configured Store API operations.

Every operation has:
- operation ID;
- endpoint/resource;
- HTTP method;
- parameter schema;
- required authorization action type;
- identity/scope requirements;
- timeout;
- retry policy;
- post-verification rule.

## 4. Consequential operation rule

For order/cart/checkout/payment-affecting operations:

```text
WF-10 authorization
 -> WF-20 parameter binding
 -> execute
 -> verify
 -> return verified result
```

Authorization must be bound to:
- request_id;
- conversation_id;
- action_id;
- action_type;
- normalized parameter hash;
- identity context;
- order scope where applicable;
- policy version;
- state version;
- idempotency key;
- short expiry.

A changed parameter set invalidates the authorization.
