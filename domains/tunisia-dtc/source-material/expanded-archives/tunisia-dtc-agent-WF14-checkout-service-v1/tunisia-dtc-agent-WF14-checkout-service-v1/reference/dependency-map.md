# Dependency map

WF-10 Action Validator
  ↓
WF-12 Cart Service
  ↓
WF-13 Promotion Service
  ↓
WF-14 Checkout Service
  ↓
Commerce Checkout Adapter
  ↓
WF-15 Transaction Service
  ↓
WF-16 Response Renderer

WF-14 is the boundary where the system prepares a checkout session/confirmation request. It must not silently mark an order as PURCHASED.
