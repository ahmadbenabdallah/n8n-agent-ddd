# WF-07 v2 Setup

1. Import `workflow/WF-07-order-service-v2.json`.
2. Import/configure WF-20 before enabling this workflow.
3. Open **Execute WF-20 Commerce Gateway** and bind it to the actual WF-20 workflow. The exported workflow intentionally uses a placeholder workflow reference `WF-20`; do not treat the placeholder as a valid production workflow ID.
4. Ensure the WF-20 contract accepts `get_order` and `get_customer_orders`.
5. Ensure upstream WF-02/verification produces trusted `woocommerce_customer_id`, `verified_email`, or `verified_phone` only after the required assurance level is reached.
6. Test all cases in `tests/test-cases.md` before connecting WF-07 to the live conversation router.

## Expected WF-20 response
`{ verified_source:true, order:{...} }` for `get_order`, or `{ verified_source:true, orders:[...] }` for `get_customer_orders`.
