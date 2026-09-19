# Requirements

## Upstream
- WF-02 Identity
- WF-03 Conversation State
- WF-04 Intent Router
- WF-06 Support Engine

## Downstream
- WF-09 LLM Reasoning
- WF-16 Response Renderer
- WF-17 Audit & Analytics

## Required commerce adapter

Provide one approved order lookup endpoint/connector that:
- authenticates with a server-side credential;
- accepts a bounded structured query;
- scopes results to the authenticated customer;
- returns a verified-source marker;
- returns an owner-match marker;
- does not expose credentials or internal notes.

## Data minimization

Allowed:
- order ID
- status
- fulfillment status
- timestamps needed for support
- estimated delivery
- tracking availability/link
- minimal item summary

Not allowed in the response contract:
- payment card data
- CVV/CVC
- authentication tokens
- internal fraud scores
- internal staff notes
- other customers' information
- unnecessary address/PII

## Important

This workflow is read-only. Refunds, cancellations, address changes, exchanges, and other mutations must use dedicated validated action workflows.
