# Tunisia DTC Agent — n8n Production Starter v1

This package matches the requested production folder structure and contains:
- 20 n8n workflow JSONs
- complete schemas
- database schema/functions/indexes/RLS
- security rules, allowlist and red-team tests
- vector-ready KB
- system-v2 reference prompts
- environment/credential documentation
- deployment/testing/production checklists

## Workflow map
WF-00 Inbound Gateway (Facebook Messenger)
WF-01 Security Gate
WF-02 Identity
WF-03 Conversation State
WF-04 Intent Router
WF-05 Sales Engine
WF-06 Support Engine
WF-07 Order Service
WF-08 Escalation
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

## Important
The workflow files are starter implementations. Provider-specific commerce/payment/shipping API contracts are intentionally not invented. Facebook Messenger is the concrete channel adapter; commerce integration must be configured against your real backend.

The LLM is never the authorization boundary:
LLM proposes -> n8n validates -> commerce executes -> n8n verifies -> response renderer sends.
