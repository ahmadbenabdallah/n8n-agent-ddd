# WF-11 Product Service v3

WF-11 now consumes WF-20 v4 commerce state. WooCommerce is authoritative whenever connected/healthy. If WF-20 reports unavailable/KB-only, WF-11 permits an informational KB fallback for product reads only.

## Hard rule

KB fallback must never manufacture live price, sale price, stock, purchasability, variation availability, order state, cart state, coupon validity, or checkout totals. Those require WooCommerce.

## Import
1. Import `n8n/WF-11-product-service-v3.json`.
2. Replace the WF-20 workflow ID.
3. Ensure the upstream RAG/Supabase path supplies `kb_context`/`kb_result` when WooCommerce is unavailable.
4. If no KB context is supplied, the workflow returns a safe `kb_fallback=true` result rather than inventing facts.
