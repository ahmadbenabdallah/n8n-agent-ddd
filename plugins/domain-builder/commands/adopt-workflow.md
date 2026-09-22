---
description: Adopt a shared workflow from platform/workflows/library.yaml into a domain, under the domain's own id.
argument-hint: [library entry and domain, e.g. "identity into demo-clinic"]
allowed-tools: Bash(bash tests/platform/shared-workflow-library.sh), Bash(pnpm validate), Read, Edit, Glob, Grep
---

Adopt a shared workflow for: $ARGUMENTS

## What adoption is

`platform/workflows/library.yaml` holds the plumbing that does not change when
the business changes (ADR 0002). A domain does not copy it and does not inherit
its ids. It **references** an entry with `from_library:` and gives it an id of
its own. The library names no domain, and the domain keeps its own naming.

## Steps

1. Read `platform/workflows/library.yaml` and pick the entry. If the user named
   a capability rather than an entry, match it on `category` and `purpose`, then
   confirm the entry with them before writing anything.

2. Read the entry's `requires_binding` and `configure` lists. `requires_binding`
   names other library entries or roles that this workflow calls; the library
   cannot name ids, so **the adopting domain supplies them**. `configure` names
   the settings the domain must decide, and some are security-relevant — e.g.
   `ALLOW_UNVERIFIED_META_WEBHOOK` must be false outside local development.

3. Choose the domain-local id. Use the domain's existing prefix, taken from its
   registry. Never reuse an id from another domain.

4. Add the entry to `domains/<domain>/workflows/registry.yaml`:

   ```yaml
   - id: <domain's own id>
     name: <name>
     category: <the library entry's category>
     scope: shared
     from_library: <library entry id>
   ```

   Add `protected: true` if the workflow fills a role named in `workflow_roles`:
   a role workflow is released from git and the operator may not edit it in n8n.

5. Create `domains/<domain>/workflows/<id>/workflow.yaml`. Model it on
   `domains/demo-booking/workflows/BOOK-IN/workflow.yaml`, which is the worked
   example of an adopted entry: it carries `from_library`, a `requires_binding`
   map resolved to that domain's own ids, and a `configure` block.

6. Verify:

   ```bash
   bash tests/platform/shared-workflow-library.sh   # every from_library resolves
   pnpm validate
   ```

   The registry must have a directory per id and a directory per id in the
   registry; `tests/runtime/workflow-sync.sh` enforces that.

Do not edit `platform/workflows/library.yaml` to fit one domain. If an entry
cannot be adopted without changing it, the entry is not domain-agnostic — say so.
