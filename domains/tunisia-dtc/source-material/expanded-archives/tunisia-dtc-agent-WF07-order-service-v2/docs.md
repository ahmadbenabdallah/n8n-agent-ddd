# WF-07 v2 — WooCommerce-backed Order Service

## What changed from v1
- Removes the old `transaction_result` placeholder pattern as the primary integration.
- Creates an explicit WF-20 commerce request.
- Calls WF-20 as the commerce adapter.
- Adds owner verification against trusted identity claims.
- Supports both `get_order` and `get_customer_orders` at the contract level.
- Treats WooCommerce as transactional source of truth.
- Keeps WF-07 strictly read-only.

## Important boundary
WF-07 authorizes disclosure; WF-20 executes the commerce read. WF-20 must not infer customer authorization from a customer-provided order number.

## Why owner verification remains here
WooCommerce REST API can retrieve an order by numeric ID, but the existence of an order ID is not proof that the Messenger user owns it. WF-07 must compare the retrieved order against a trusted owner scope.

## WooCommerce facts used
WooCommerce REST API v3 exposes order id/number/status, customer_id, billing/shipping data, line items, shipping lines, coupon lines, and timestamps. WF-07 uses only a minimized subset.
