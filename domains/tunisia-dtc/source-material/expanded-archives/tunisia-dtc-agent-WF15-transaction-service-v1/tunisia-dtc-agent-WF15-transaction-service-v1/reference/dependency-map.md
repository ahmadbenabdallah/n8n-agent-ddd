# Dependency map

WF-10 Action Validator
  ↓
WF-14 Checkout Service
  ↓
WF-15 Transaction Service
  ↓
Commerce / PSP Adapter
  ↓
Post-transaction verification
  ↓
WF-16 Response Renderer
  ↓
WF-17 Audit & Analytics

WF-15 is the final execution boundary for the transaction. WF-16 must only render verified results.
