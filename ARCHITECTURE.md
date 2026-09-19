# Architecture

n8n Agent DDD is a framework for building domain-driven AI business agents. n8n runs the workflows; Postgres holds the durable state; business rules live in versioned domain packs. `domains/tunisia-dtc` is the reference example.

## Layers

| Layer | Folder | Holds |
|---|---|---|
| Specification | `spec/`, `contracts/` | Platform contracts, invariants, schemas and release specs. Nothing domain-specific. |
| Platform | `platform/` | Reusable, domain-agnostic capabilities: state and schema, capabilities, configuration, ownership, observability. |
| Domains | `domains/<domain>/`, `templates/domain-pack/` | Business logic as a domain pack: model, policies, workflow contracts, prompts, adapters, tests. The template is the starter for a new domain. |
| Runtime | `runtime/`, `infrastructure/` | What actually runs: n8n workflows, the database, Redis, the reverse proxy, monitoring, deployment. |
| Agent system | `.agents/`, `.claude/`, `.codex/`, `harness/` | Skills, roles and policies for the AI developers working on this repo, plus the harness control plane. Not part of the customer runtime. |

## Runtime model

```
channel (e.g. Messenger)
  -> WF-00 inbound gateway  -> WF-01 security gate -> WF-02 identity -> WF-03 conversation state
  -> WF-04 intent router    -> WF-09 LLM reasoning (proposes only)
  -> WF-10 action authorization      <- the only place an action becomes allowed
  -> WF-20 commerce gateway          <- the only place a commerce system is changed
  -> provider verification -> WF-16 response (verified facts only)
  -> WF-17 audit           -> WF-19 reconciliation of unknown outcomes
```

- **State:** Postgres is the source of truth for domain state (identities, conversations, carts, orders, authorizations, audit, knowledge). Supabase is one supported provider; any Postgres works. Migrations live in `platform/state/db/migrations` and are provider-neutral, with provider-specific statements in `platform/state/db/profiles/`.
- **Commerce:** the commerce platform (WooCommerce in the reference domain) stays the source of truth for products, prices, stock and orders.
- **Queue:** Redis is optional, for n8n queue mode with workers.
- **Knowledge:** pgvector inside the same Postgres.

## Principles

- Compute is disposable; state is durable. Domain state never depends on n8n execution history.
- The LLM proposes; it never authorizes.
- Business rules are versioned with the domain pack.
- External mutations are idempotent, and unknown outcomes are reconciled before any retry.
- Deployments are reversible.

## Ports and adapters

Channels and commerce platforms sit behind ports (`contracts/platform/`), so a domain can change provider without changing its rules. Today `ChannelPort` and `CommercePort` are specified; Identity, Payment, Knowledge and Observability ports are planned.

## Current state

The layers, contracts and the database schema exist. The runtime does not yet: 17 of the 21 workflows are stubs, the WF-10 to WF-20 authorization handshake is not enforced, and the deployment scripts are placeholders. See the project status section of `README.md`.
