# WF-14 — Checkout Service v1

Transactional boundary between the validated cart and final order/transaction creation.

## Scope
- checkout start
- checkout confirmation boundary
- cart snapshot
- customer/shipping data validation
- payment-method eligibility boundary
- live price/stock/promotion revalidation
- idempotency
- commerce adapter request
- post-action verification

## Critical rule
WF-14 does NOT create a paid order by itself. The commerce adapter owns final transaction/order creation. Never tell the customer an order is confirmed unless the adapter returns verified confirmation.

Architecture:

WF-10 → WF-14 → live checkout/commerce adapter → verification → WF-15 Transaction Service

Import the JSON into n8n. Keep inactive until the adapter and trusted live validation source are connected.
