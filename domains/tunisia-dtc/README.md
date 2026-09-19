# Tunisia DTC Reference Domain

This directory contains the complete Tunisia DTC reference-domain material carried into the v0.20.3 cumulative repository.

## Canonical areas

- `prompts/` — system and orchestrator prompts
- `contracts/` — KB, sales, tool, LLM output and workflow contracts
- `security/` — security policy
- `testing/` — red-team suite
- `source-material/` — exact source packages from the Tunisia DTC implementation work, including workflow-specific specifications and integration guides

## 21 workflow architecture

WF-00 through WF-20 are the reference runtime architecture. The workflow-specific source packages present in `source-material/` preserve the detailed specifications that were produced for the individual workflow slices. Where a workflow-specific package was not produced as a separate archive, its contract/catalog remains in the workflow catalog and the platform's canonical workflow inventory.

The runtime invariant is:

```text
LLM proposes
→ n8n validates
→ WF-10 authorizes
→ WF-20 executes
→ WooCommerce verifies
→ WF-16 renders
→ WF-17 audits
→ WF-19 monitors/reconciles
```

## Important

The Tunisia domain is the first concrete reference implementation. It is not the boundary of the platform; future domains should implement the same platform contracts and their own business logic.
