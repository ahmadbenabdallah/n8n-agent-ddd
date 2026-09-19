# Tunisia DTC Agent — n8n Build v3

This package is the executable-oriented workflow blueprint following the earlier architecture/specification packages.

It defines:
- workflow boundaries;
- node sequences;
- canonical JSON contracts;
- authorization gates;
- sales/support routing;
- cart/promotion/checkout controls;
- order privacy;
- response rendering;
- analytics;
- deployment sequence.

## Security baseline

OWASP states that its 2026 LLM Top 10 is the latest edition. It also published an Agent Control Standard and a 2026 Top 10 for Agentic Applications. This build therefore treats runtime authorization, identity, tool control and audit as first-class controls rather than relying on prompt instructions alone.

## Important

Exact n8n node names/options can vary by installed n8n version and by the chosen commerce/channel providers. This package intentionally specifies the contract and logic first so the workflow can be implemented against the actual environment without inventing provider-specific details.
