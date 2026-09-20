# Security and Data Boundary

1. WF-11 accepts a bounded operation enum.
2. No arbitrary WooCommerce endpoint/path is accepted from the LLM.
3. WF-20 owns credentials and WooCommerce access.
4. Product `meta_data` is not returned by WF-11.
5. Payment/customer/order information is outside this workflow.
6. Search pagination is bounded to 50 items per request.
7. The normalized response is the only contract exposed to downstream agent logic.
8. Availability is calculated from WooCommerce live fields; it is not inferred from KB text.
