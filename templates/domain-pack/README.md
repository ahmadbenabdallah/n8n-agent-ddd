# Domain pack template

A starter for a new domain agent. `domains/tunisia-dtc/` is the complete worked example of every file here.

## How to use it

1. Copy this folder to `domains/<your-domain-id>/`.
2. Replace every `<...>` placeholder.
3. Keep every entry marked **platform-required**: those entries bind your domain to the platform's safety boundaries: the authorization, privileged_external_execution, response_rendering, audit and reconciliation roles.
4. Run `pnpm validate`.

## Layout

| Path | Required | Holds |
|---|---|---|
| `domain.yaml` | yes | identity, bounded contexts, actors, sources of truth, runtime invariants |
| `domain-project.yaml` | yes | n8n project and namespace, adapters, Postgres schema, vector namespace |
| `business/` | yes | business rules (`BR-<AREA>-NNN`) |
| `entities/`, `aggregates/`, `value-objects/` | yes | the domain model |
| `commands/`, `events/`, `projections/` | yes | what the domain does, what it records, what it reads back |
| `policies/` | yes | who may do what (includes the platform-required policies) |
| `workflows/` | yes | `registry.yaml`, plus one `<workflow-id>/workflow.yaml` contract per workflow |
| `knowledge/` | yes | documents for the knowledge base, ingested by the knowledge workflow |
| `adapters/` | yes | which channel and commerce adapters the domain uses |
| `tests/` | yes | domain invariant test cases |
| `prompts/`, `contracts/`, `security/` | optional | LLM prompts, domain contracts, security policy |

The required list comes from `spec/domains/domain-pack-contract.yaml`. `pnpm validate` checks this template, and every folder in `domains/`, against it.
