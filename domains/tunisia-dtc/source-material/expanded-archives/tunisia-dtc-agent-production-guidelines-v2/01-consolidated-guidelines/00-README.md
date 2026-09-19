# Tunisia DTC AI Commerce Agent — Production Guidelines v2

This package consolidates the previous production guide with the rebuilt WooCommerce commerce layer.

## Current deployment assumptions

- Commerce: WooCommerce
- Payment: Cash on Delivery (COD)
- Shipping: manual initially
- Orchestration: self-hosted n8n
- First channel: Meta Messenger
- AI: OpenAI
- RAG: Supabase + pgvector

## Core architecture

LLM proposes → n8n validates/authorizes → commerce executes → n8n verifies → renderer replies.

The LLM is a reasoning/proposal layer, never the commerce source of truth.

## Commerce source of truth

WooCommerce is authoritative for mutable transactional facts:
- products
- variations
- current prices
- stock
- purchasability
- coupons/promotions
- carts
- checkout state
- orders

The Knowledge Base remains authoritative only for the factual content actually ingested into it, such as product descriptions, features, usage/care guidance and approved marketing information. KB content must not override live WooCommerce price, stock, eligibility or order state.

## Security boundary

WF-10 remains the authorization boundary.

WF-20 is the only privileged WooCommerce integration boundary.

WF-16 is the customer-facing rendering boundary.

WF-17 is the audit/analytics boundary.

## Current commerce workflow set

- WF-07 Order Service v2
- WF-11 Product Service v2
- WF-12 Cart Service v2
- WF-13 Promotion Service v2
- WF-14 Checkout Service v2
- WF-15 Transaction Service v2
- WF-20 WooCommerce Gateway v3

## Important implementation principle

Do not duplicate WooCommerce credentials or WooCommerce API calls across domain workflows. Domain workflows call WF-20 using bounded operations.

## Production status

These guidelines are implementation guidance and integration contracts. Production readiness still requires:
- actual credentials
- real WooCommerce staging store
- actual n8n workflow IDs
- Store API cart-token persistence
- exact native-node field verification for the installed n8n version
- Meta webhook/channel integration
- human-support destination
- durable idempotency
- staging E2E tests
- security/red-team tests
- load testing
- backups/retention
- monitoring/alerting
- canary and rollback procedures
