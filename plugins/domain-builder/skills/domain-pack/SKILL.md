---
name: domain-pack
description: How a domain pack for the n8n-agent-ddd framework is structured, and how platform roles map to a domain's own workflow ids. Use when creating, editing or reviewing anything under domains/, templates/domain-pack/ or platform/workflows/ — especially before writing a workflow id, a workflow_roles block, or a registry entry.
---

# Domain packs

A domain pack is the whole specification of one business agent: its model, its
rules, its policies and its workflow contracts. The framework runs it; the
framework does not contain it. `domains/tunisia-dtc/` and
`domains/demo-booking/` are two examples, not the product.

## The rule that is easiest to break

**The platform names no workflow id.** Not in platform code, not in specs, not
in contracts, not in a scaffold, not in a suggestion to the user.

The platform defines five *roles*:

| Role | Invariant |
|---|---|
| `authorization` | the only workflow that may allow an action; fails closed |
| `response_rendering` | replies carry verified facts only |
| `audit` | append-only record; audit is never authorization |
| `reconciliation` | an unknown external outcome is settled before any retry |
| `privileged_external_execution` | the only workflow that may change an external system of record |

Each domain maps those roles to **its own ids**, in `domain.yaml`:

```yaml
workflow_roles:
  authorization: <this domain's id>
  response_rendering: <this domain's id>
  audit: <this domain's id>
  reconciliation: <this domain's id>
```

`tunisia-dtc` happens to use `WF-`-prefixed ids and `demo-booking` uses
`BOOK-` ones. Neither is a convention. If you are about to write a literal
workflow id into anything outside a single domain's own directory, stop: that
is the ADR 0001 violation this skill exists to prevent.

`privileged_external_execution` is required **only** when
`sources_of_truth.commerce` is not `none`. A domain that changes nothing
outside its own Postgres declares four roles and is complete;
`domains/demo-booking/` is the proof.

## Required sequence

1. Read `spec/domains/domain-pack-contract.yaml` for the required entries, and
   `templates/domain-pack/` for their shape. Never restate the required list
   from memory — read it.
2. To create a pack, run the scaffold rather than copying by hand:
   `node "${CLAUDE_PLUGIN_ROOT}/scripts/scaffold-domain.mjs" --help`. Copying by
   hand is how the template last rotted (`runtime/evidence/validation/F1.md`).
3. Choose the domain's id prefix with the user, then map every required role to
   an id under that prefix.
4. For plumbing, adopt from `platform/workflows/library.yaml` with
   `from_library:` and a domain-local id, rather than writing it. Resolve the
   entry's `requires_binding` to this domain's ids, and decide its `configure`
   keys explicitly.
5. Keep `domain.yaml` `workflow_roles`, `workflows/registry.yaml` and the
   `workflows/<id>/` directories in agreement. All three are checked.
6. Run `pnpm validate`, then `pnpm test`.

## Safety

- Never write a workflow id from one domain into another domain, into
  `platform/`, `spec/`, `contracts/` or into generated output.
- Never let an LLM step authorize. Reasoning proposes; the `authorization` role
  decides. A workflow contract that lets a model set `execution_allowed` is
  wrong however plausible it reads.
- Never relax a validator, a platform contract or a `spec/invariants/` entry so
  a domain passes. The domain is what has to fit.
- Never invent a business rule the user did not state. An unstated rule in
  `business/business-rules.yaml` is a fabricated requirement that later reads as
  agreed.
- Never put a runtime secret in a pack. `configure` keys name what must be set;
  the values live in the runtime's secret store.
- `commerce: none` is a decision with consequences, not a default. Confirm it.
