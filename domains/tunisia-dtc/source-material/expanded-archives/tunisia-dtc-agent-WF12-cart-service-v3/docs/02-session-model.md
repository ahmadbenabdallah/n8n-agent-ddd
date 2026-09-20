# WooCommerce Cart Session Model

`wc_cart_sessions` maps:

`customer_id + channel + store_id -> cart_reference`

The raw WooCommerce Store API Cart-Token is intentionally not passed through WF-12.

WF-20 is responsible for protected token resolution/storage.

This avoids treating a customer-provided token as an authorization credential and prevents token leakage into LLM context, general audit data, or customer-facing responses.

A cart session may expire or become invalid. WF-20 should mark it invalid and establish a new session when the Store API requires it.
