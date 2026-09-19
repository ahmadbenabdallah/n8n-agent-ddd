---
title: n8n Workflow Development
category: Development
order: 4
---

# n8n Workflow Development

n8n is the orchestration runtime.

## Canonical workflow set

The reference runtime contains exactly:

`WF-00 … WF-20`

Protected workflows:

- WF-01 Security Gate
- WF-10 Action Authorization
- WF-15 Transaction/Payment
- WF-20 WooCommerce Gateway

Protected workflows are release-controlled.

## Workflow rules

- Keep each workflow responsibility narrow.
- Validate input at boundaries.
- Keep authorization explicit.
- Keep provider-specific behavior in adapters.
- Use durable state for business mutations.
- Use idempotency for mutations.
- Verify external state after mutations.
- Audit important state transitions.
- Keep secrets in credential/deployment mechanisms.

## Operator UI

Do not build a competing workflow editor. n8n already provides the operator dashboard for workflow editing, projects, credentials, and executions.

## Workflow sync

Workflow source and release state must be synchronized through the repository's controlled workflow-sync process. Manual production edits should not become an undocumented source of truth.
