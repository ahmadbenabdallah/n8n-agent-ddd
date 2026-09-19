---
name: n8n:workflow-debugging
description: Diagnose n8n workflow failures using execution evidence, contracts, logs and runtime boundaries.
---

# n8n:workflow-debugging

## Required sequence

1. Identify the workflow and version.
2. Capture the failing execution evidence.
3. Trace input/output contracts.
4. Identify the first violated invariant.
5. Reproduce safely.
6. Fix the smallest root cause.
7. Validate and test.
8. Record operational implications.

## Safety

Do not use production customer data as a debugging shortcut. Never expose credentials or secrets in logs, prompts or issue reports.
