# Tunisia DTC AI Agent — Final Production System v3

## Purpose
Production-aligned source-of-truth specification for a Tunisia-focused DTC sales and support AI agent.

## Runtime invariant
**LLM proposes → n8n validates/authorizes → commerce executes → n8n verifies → renderer replies.**

## Boundaries
- **WF-10:** sole hard authorization boundary.
- **WF-20:** sole privileged WooCommerce integration boundary.
- **WF-16:** customer-facing response boundary.
- **WF-17:** audit/analytics only; never an authorization source.
- **WooCommerce:** authoritative for live stock, current price, cart, coupon validity, checkout total, order status and payment status.
- **Supabase:** identity/context/orchestration state and RAG vector store.
- **LLM:** reasoning/proposal only.

## Workflows
WF-00 Inbound Gateway
WF-01 Security Gate
WF-02 Identity
WF-03 Conversation State
WF-04 Intent Router
WF-05 Sales Engine
WF-06 Support Engine
WF-07 Order Service
WF-08 Escalation Engine
WF-09 LLM Reasoning
WF-10 Action Validator
WF-11 Product Service
WF-12 Cart Service
WF-13 Promotion Service
WF-14 Checkout Service
WF-15 Transaction Service
WF-16 Response Renderer
WF-17 Audit & Analytics
WF-18 KB Ingestion
WF-19 Maintenance & Monitoring
WF-20 WooCommerce Gateway

## Production rule
Do not treat this package as executable n8n JSON. It is the final contract/specification layer from which n8n workflows, credentials, environment configuration and test fixtures are implemented.

## Critical payment semantics
Cash on Delivery (COD) is the initial payment method. Creating an order does **not** mean payment was received. A newly created COD order must remain `payment_status=not_paid` unless WooCommerce independently confirms otherwise.

## Security
No PAN, CVV, OTP, PIN, passwords, API keys, WooCommerce secrets, Cart-Tokens or Nonce Tokens may enter LLM/customer-visible/logging contexts.
