# Dependency map

WF-00 Inbound Gateway
  ↓
WF-01 Security Gate
  ↓
WF-02 Identity
  ↓
WF-03 Conversation State
  ↓
WF-04 Intent Router
  ↓
WF-05 Sales / WF-06 Support
  ↓
WF-09 LLM Reasoning
  ↓
WF-10 Action Validator
  ↓
WF-12 Cart Service
  ↓
Commerce Cart Adapter
  ↓
Post-action verification
  ↓
WF-16 Response Renderer
  ↓
WF-17 Audit

WF-12 must never be reachable as an unvalidated public endpoint.
