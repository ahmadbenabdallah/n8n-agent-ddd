# Dependency map

WF-04 Intent Router
  ↓
WF-09 LLM Reasoning (proposal only)
  ↓
WF-10 Action Validator
  ↓
WF-13 Promotion Service
  ↓
Live Promotion / Commerce Adapter
  ↓
WF-14 Checkout Service

WF-11 Product Service may supply product/category facts, but live promotion eligibility remains authoritative in the promotion/commerce system.

WF-13 does not mutate carts, orders, payments or promotion usage.
