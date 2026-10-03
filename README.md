# n8n Agent DDD

**A framework for building domain-driven AI business agents, with n8n as the runtime.**

[![Status](https://img.shields.io/badge/status-early%20development-orange)](#project-status)
[![Version](https://img.shields.io/badge/version-0.13.3-blue)](#project-status)
[![License](https://img.shields.io/badge/license-Apache--2.0-green)](#license)

Repository: [github.com/ahmadbenabdallah/n8n-agent-ddd](https://github.com/ahmadbenabdallah/n8n-agent-ddd) · Documentation: [`documentation/`](documentation/) · Licence: [Apache-2.0](LICENSE)

> **Status: the architecture and contracts are in place; the runtime is not.** Every workflow in `runtime/n8n/workflows/` is a placeholder, the authorization and execution boundary is not enforced yet, and the deployment scripts print rather than deploy. The system has never run end to end. See [Project status](#project-status) before planning anything on top of it.

---

## Contents

**Understand** · [What is n8n Agent DDD?](#what-is-n8n-agent-ddd) · [Why does it exist?](#why-does-it-exist) · [Core idea](#core-idea) · [Architecture](#architecture) · [Runtime model](#runtime-model) · [AI-SDLC and Harness](#ai-sdlc-and-harness) · [Domain-driven architecture](#domain-driven-architecture) · [Security model](#security-model) · [Supported integrations](#supported-integrations) · [Current reference domain](#current-reference-domain)

**Build** · [Quick start](#quick-start) · [Installation](#installation) · [Development](#development) · [Testing](#testing) · [Deployment](#deployment) · [Operations](#operations) · [Documentation](#documentation)

**Project** · [Roadmap](#roadmap) · [Project status](#project-status) · [Contributing](#contributing) · [Security](#security) · [Governance](#governance) · [Code of Conduct](#code-of-conduct) · [Support](#support) · [Changelog](#changelog) · [License](#license) · [Acknowledgements](#acknowledgements)

---

## What is n8n Agent DDD?

A framework for building autonomous business agents that hold conversations with customers and take real actions on business systems, without letting the language model decide what is allowed.

Each layer is prepared so you can build your own agent:

- **A domain pack**: your business model as data, not code, in entities, aggregates, policies, commands, events and workflow contracts.
- **A workflow chain**: from inbound message to audited action, with fixed boundaries between reasoning, authorization and execution. The plumbing (channel connector, security gate, conversation state, identity, reasoning shell, authorization engine, renderer, audit, knowledge ingestion, reconciliation, execution gateway) is shared and configured by your domain; you write only your own business workflows.
- **Durable state**: PostgreSQL holds identities, conversations, authorizations, orders and audit records. n8n execution history is transient and never the source of truth.
- **Ports and adapters**: the channel (Messenger, WhatsApp) and the business system (WooCommerce, Shopify) sit behind contracts, so the domain rules do not change when the provider does.
- **Agent development support**: shared skills, roles and policies for Claude Code and Codex, so the repository can be worked on by AI agents under explicit rules.

`domains/tunisia-dtc` is the reference example: a Tunisian direct-to-consumer sales and support assistant on Facebook Messenger with WooCommerce cash-on-delivery orders, speaking Tunisian Arabizi. It is the worked example, not the product.

## Why does it exist?

An LLM connected directly to a shop API is a liability. It can be talked into a discount, invent a price, place an order twice, or act on a message that was never sent by the customer.

The usual answers are to prompt more carefully, or to wrap the model in ad hoc checks scattered across an automation. Neither survives contact with a real business, because neither produces a boundary you can point at, test and audit.

This framework takes the opposite approach: the model proposes, a separate workflow authorizes against durable state and policy, and a single privileged workflow executes. What the customer is told comes from verified facts. Every decision leaves an audit record. Those boundaries are written down as contracts and invariants, so they can be checked rather than assumed.

## Core idea

```text
  propose            authorize              execute            verify
 ─────────►         ──────────►            ────────►          ────────►
   LLM        →   authorization   →    execution gateway →  provider check
(suggests)        (decides, using      (the only writer     (confirm what
                   durable state        to the business      actually happened)
                   and policy)          system)
```

Four rules follow from that shape, and the rest of the design follows from them:

1. **The model never authorizes.** Its output is a proposal with no authority.
2. **One authorizer.** A single workflow decides, from stored identity, scope, policy and live business state.
3. **One executor.** A single workflow may change the business system, and only with an authorization it can verify.
4. **Uncertainty is reconciled, not retried.** If an external call may have succeeded, the outcome is established before anything is attempted again.

These are **roles**, not fixed workflow names. Each domain declares which of its workflows fills each role, in `domain.yaml` under `workflow_roles`; the Tunisia example uses WF-10 for authorization and WF-20 for execution.

The full list lives in [`AGENTS.md`](AGENTS.md) and [`spec/invariants/platform.yaml`](spec/invariants/platform.yaml).

## Architecture

```text
┌──────────────────────────────────────────────────────────────┐
│ domains/<your-domain>/        your business model as data     │
│   entities · aggregates · policies · workflow contracts       │
└───────────────────────────┬──────────────────────────────────┘
                            │ built on
┌───────────────────────────▼──────────────────────────────────┐
│ platform/       reusable capabilities (state, identity,       │
│                 authorization, audit, reconciliation)         │
│ contracts/      what each side must honour                    │
│ spec/           invariants, schemas, release specs            │
└───────────────────────────┬──────────────────────────────────┘
                            │ runs on
┌───────────────────────────▼──────────────────────────────────┐
│ runtime/        n8n workflows · PostgreSQL · Redis · proxy    │
│ infrastructure/ docker, environments, deployment              │
└──────────────────────────────────────────────────────────────┘

  harness/ + .agents/ + .claude/ + .codex/   development control plane
  (planning, validation and agent rules; not part of the customer runtime)
```

| Directory | Holds |
|---|---|
| [`spec/`](spec/) | Platform specifications: invariants, schemas, lifecycle, releases |
| [`contracts/`](contracts/) | Contracts for the platform, domains and external providers |
| [`platform/`](platform/) | Reusable TypeScript capabilities; `platform/state` holds the schema, migrations and provider profiles |
| [`domains/`](domains/) | Domain packs; `tunisia-dtc` is the reference example |
| [`templates/domain-pack/`](templates/domain-pack/) | The starter you copy to build your own domain |
| [`runtime/`](runtime/) | n8n workflows, database profile, Redis, reverse proxy, monitoring, evidence |
| [`infrastructure/`](infrastructure/) | Docker compose files, environment examples, deployment |
| [`harness/`](harness/) | Development control plane (thin; see [AI-SDLC and Harness](#ai-sdlc-and-harness)) |
| [`scripts/`](scripts/) | Validation, runtime, database, release and operations scripts |
| [`tests/`](tests/) | Contract and architecture checks |
| [`documentation/`](documentation/) | Public reference documentation |
| [`.agents/`](.agents/), [`.claude/`](.claude/), [`.codex/`](.codex/) | Shared agent skills and policies, plus the Claude Code and Codex adapters |

Canonical locations, so nothing has two homes:

| Thing | Lives in |
|---|---|
| Executable workflows | `runtime/n8n/workflows/` |
| Workflow contracts | `domains/<domain>/workflows/WF-xx/workflow.yaml` |
| Workflow registry | `domains/<domain>/workflows/registry.yaml` |
| Database migrations | `platform/state/db/migrations/` (provider-neutral) |
| Provider-specific SQL | `platform/state/db/profiles/<provider>/` |
| Agent contract | [`AGENTS.md`](AGENTS.md), with [`agent-manifest.yaml`](agent-manifest.yaml) |

## Runtime model

A message arrives, and the chain runs. The chain below is the **reference domain's** (`domains/tunisia-dtc`) and the ids are its own; another domain fills the same roles with its own ids, and need not have the same number of workflows:

```text
customer message
      │
  WF-00 inbound gateway ──► WF-01 security gate ──► WF-02 identity
      │
  WF-03 conversation state ──► WF-04 intent router
      │
      ├─► WF-05 sales · WF-06 support · WF-07 orders · WF-08 escalation
      │        │
      │   WF-09 LLM reasoning (proposes only)
      │        │
      │   WF-10 action authorization ◄── durable state, scope, policy
      │        │ authorized
      │   WF-20 WooCommerce gateway (the only writer)
      │        │
      │   provider verification
      │
  WF-16 response renderer (verified facts only)
      │
  WF-17 audit · WF-19 reconciliation and monitoring
```

All 21 of the reference domain's workflows are currently placeholders. The table gives each one's purpose and where its contract lives.

| ID | Name | Category | Runtime status |
|---|---|---|---|
| WF-00 | Inbound Gateway | ingress | Placeholder |
| WF-01 | Security Gate | security | Placeholder |
| WF-02 | Customer Identity | identity | Placeholder |
| WF-03 | Conversation State | state | Placeholder |
| WF-04 | Intent Router | routing | Placeholder |
| WF-05 | Sales Engine | domain | Placeholder |
| WF-06 | Support Engine | domain | Placeholder |
| WF-07 | Order Service | commerce | Placeholder |
| WF-08 | Escalation Engine | human handoff | Placeholder |
| WF-09 | LLM Reasoning | reasoning | Placeholder |
| WF-10 | Action Authorization | authorization | Placeholder |
| WF-11 | Product Service | commerce | Placeholder |
| WF-12 | Cart Service | commerce | Placeholder |
| WF-13 | Promotion Service | commerce | Placeholder |
| WF-14 | Checkout Service | commerce | Placeholder |
| WF-15 | Transaction / Payment | payment | Placeholder |
| WF-16 | Response Renderer | rendering | Placeholder |
| WF-17 | Audit and Analytics | audit | Placeholder |
| WF-18 | Knowledge Base Ingestion | knowledge | Placeholder |
| WF-19 | Maintenance and Monitoring | operations | Placeholder |
| WF-20 | WooCommerce Gateway | privileged execution | Placeholder |

A placeholder is a valid n8n workflow of three or four Code nodes that passes data through. It has no trigger and calls nothing. WF-10 and WF-20 are the exception to "passes through": they refuse a payload that carries its own authorization, because that is the one thing they must not forward (the decision itself is [`platform/authorization/port.ts`](platform/authorization/port.ts)).

The design work behind each workflow is kept per workflow in [`domains/tunisia-dtc/workflow-packages/`](domains/tunisia-dtc/workflow-packages/): one folder per WF-xx with its specification, validation pipeline, n8n implementation notes, security tests, end-to-end flows and setup guides, plus the fuller workflow JSON for WF-00, WF-01, WF-02 and WF-04. Older versions and the implementation guides sit under `source-material/`; [`SOURCE-MATERIAL-INDEX.md`](domains/tunisia-dtc/SOURCE-MATERIAL-INDEX.md) explains both. All of it is reference, not the executable set.

**State.** PostgreSQL holds 18 tables: identities, conversations and conversation state, carts and cart items, order scopes, orders, actions, authorizations, execution operations, transactions, escalations, audit events, idempotency keys, knowledge documents, and the operator configuration tables. Row level security is enabled everywhere with no policies, so nothing is readable without an explicit grant. Audit events are append-only, enforced by a trigger. Idempotency runs through a `private.reserve_idempotency` function rather than application code. See [`platform/state/db/migrations/`](platform/state/db/migrations/).

**Provider neutrality.** The migrations run on any PostgreSQL. Supabase is one supported profile: its Data API roles are handled by `platform/state/db/profiles/supabase/`, applied only when `DATABASE_PROFILE=supabase`.

## AI-SDLC and Harness

This is the development layer, not the customer runtime. It exists so AI coding agents can work in the repository under explicit rules:

- [`AGENTS.md`](AGENTS.md) is the canonical contract for any agent or contributor, with [`agent-manifest.yaml`](agent-manifest.yaml) as the machine-readable index.
- [`.agents/`](.agents/) holds shared skills and policies; [`.claude/`](.claude/) and [`.codex/`](.codex/) are the adapters for Claude Code and Codex, and [`CLAUDE.md`](CLAUDE.md) points Claude Code at the contract.
- [`harness/`](harness/) is the control plane. What works today is `pnpm harness doctor`, `validate` and `test`; `plan` and `security` are aliases of `validate`. The planner, orchestrator, runners, advisor and worktree model are specified in [`spec/harness/`](spec/harness/) but not implemented.

Working on the repository with an agent: open it with Claude Code or Codex, let it read `AGENTS.md`, then work through `pnpm validate` and `pnpm test`.

## Domain-driven architecture

A domain pack is the business model as data. The platform reads it; you do not fork the platform to add a domain.

| Folder | Holds |
|---|---|
| `domain.yaml` | Identity, bounded contexts, actors, identity ladder, sources of truth, invariants |
| `domain-project.yaml` | n8n project and namespace, adapters, database schema, vector namespace |
| `business/` | Business rules, each with an id |
| `entities/`, `aggregates/`, `value-objects/` | The model and its invariants |
| `commands/`, `events/`, `projections/` | What the domain does, records and reads back |
| `policies/` | Who may do what, including the platform-required authorization policies |
| `workflows/` | The registry and one contract per workflow |
| `knowledge/` | Documents for the knowledge base |
| `adapters/` | Which channel and business system this domain uses |
| `tests/` | Domain invariant cases |

The required set is defined in [`spec/domains/domain-pack-contract.yaml`](spec/domains/domain-pack-contract.yaml) and checked by `pnpm validate`.

### Build your own domain agent

1. Copy [`templates/domain-pack/`](templates/domain-pack/) to `domains/<your-domain-id>/`.
2. Replace every `<...>` placeholder. Keep the entries marked **platform-required**: they bind your domain to the authorization, execution, audit and reconciliation boundaries.
3. Model your business: rules in `business/`, the model in `entities/` and `aggregates/`, what may happen in `commands/` and `policies/`.
4. Declare your workflows in `workflows/registry.yaml`, and give each one a contract.
5. Choose adapters in `domain-project.yaml`.
6. Run `pnpm validate`.

[`domains/tunisia-dtc/`](domains/tunisia-dtc/) is the same structure filled in, and [`documentation/development/domain-development.md`](documentation/development/domain-development.md) covers the workflow in more depth.

Note the honest limit: a domain pack is currently a complete, validated description of a domain. Turning it into a running agent needs the workflow layer, which is the work described under [Roadmap](#roadmap).

## Security model

The boundaries the framework is built around, and how far each one has got. **Designed** means written in prose, **contracted** means specified in a contract or spec file that validation checks, **implemented** means code or SQL enforces it.

| Boundary | State |
|---|---|
| LLM output cannot authorize business actions | Implemented ([`platform/authorization/port.ts`](platform/authorization/port.ts): the proposal type has no `execution_allowed` member, a supplied one is stripped and the request denied) |
| Only the workflow filling the `authorization` role may authorize execution | Implemented (`authorizeAction` is the only writer of `execution_allowed`, and it writes it to `public.authorizations`) |
| Only the workflow filling the `privileged_external_execution` role may perform privileged mutations | Implemented (`requireAuthorizedExecution` resolves the role from the domain's `workflow_roles` and refuses any other caller) |
| The renderer reports verified facts only | Contracted |
| Audit is a record, never a permission | Implemented in the database (append-only trigger) |
| Domain state does not depend on n8n execution history | Implemented as schema |
| Secrets never reach source control, the model or the customer | Contracted, plus repository ignore rules |
| Unknown external outcomes reconcile before retry | Contracted |
| Order creation is not payment | Designed |
| Human ownership blocks conflicting automation | Contracted |
| Durable idempotency for external mutations | Implemented in the database (`private.reserve_idempotency`) |
| Inbound webhook signatures are verified before anything is processed | Implemented ([`platform/channels/meta-signature.ts`](platform/channels/meta-signature.ts) and the `messenger-inbound` gateway: HMAC-SHA256 over the raw body, constant-time, before normalisation; a replayed event id is dropped) |

**Not enforced yet, and worth being blunt about:**

- Authorization is a stored record, not a payload flag: the port writes a row to `public.authorizations` and the executor loads it back by `authorization_id`, requiring `AUTHORIZED`, `execution_allowed`, an unexpired window and a matching action. What is **not** done: the n8n graphs do not call it. WF-10 and WF-20 are still placeholders that only refuse to contradict the code, so the boundary holds wherever the platform code runs and nowhere else yet. Nine of the eleven business gates in [`01-WF-10-AUTHORIZATION-SPEC.md`](domains/tunisia-dtc/workflow-packages/WF-10/01-WF-10-AUTHORIZATION-SPEC.md) (ownership, freshness, business policy, parameter constraints) are still domain policy to come; identity assurance and the action allowlist are in.
- The authorization record has never been written to a real PostgreSQL. The decision and the gate are unit-tested against a store double and an in-memory `private.reserve_idempotency`; the live path needs Docker and has not been run.
- Webhook signature verification is implemented and unit-tested, but like everything else here it has never run against Meta's own requests. The n8n-level check (forged header to the live stack, expect 403) is still unexecuted.
- The reconciliation path exists in the database and in specification, but nothing calls it.

Reporting a vulnerability: [`SECURITY.md`](SECURITY.md).

## Supported integrations

| Integration | Role | State |
|---|---|---|
| PostgreSQL | Durable state | Schema and migrations implemented |
| Supabase | PostgreSQL provider profile | Implemented as a profile |
| pgvector | Knowledge embeddings | Column and index in the schema |
| n8n | Workflow runtime | Version pinned, local stack runs |
| Redis | n8n queue mode | Configured for staging and production, absent from the local stack |
| Meta Messenger | Channel | Contract specified, adapter not implemented |
| WooCommerce | Business system | Contract specified, adapter not implemented |
| LLM provider | Reasoning | Contract specified; no provider wired in |
| WhatsApp, Instagram, Telegram, web chat | Channels | Planned |
| Shopify, PrestaShop, custom APIs | Business systems | Planned |

Contracts for the current set live in [`contracts/external/`](contracts/external/) and [`contracts/platform/`](contracts/platform/).

## Current reference domain

**Tunisia DTC**: a sales and support assistant for a Tunisian direct-to-consumer shop.

- **Channel**: Facebook Messenger.
- **Business system**: WooCommerce, with cash-on-delivery orders.
- **Language**: Tunisian Arabizi (Tunisian Arabic in Latin script) mixed with French, with a rule against replying in Arabic script unless the customer uses it.
- **Bounded contexts**: customer identity, conversation, commerce, payment, support, knowledge, governance.
- **Identity ladder**: anonymous, channel-linked, commerce-matched, order-verified, high-assurance. Actions require a level, and the model cannot promote anyone.

It exists to prove the framework against a real business with real money, and to serve as the example you read while building your own. See [`domains/tunisia-dtc/README.md`](domains/tunisia-dtc/README.md).

## Quick start

Repository work is ready today. Running an agent is not, and the steps below say where the line is.

```bash
git clone https://github.com/ahmadbenabdallah/n8n-agent-ddd.git
cd n8n-agent-ddd
pnpm install
pnpm run doctor      # environment and repository structure
pnpm validate    # agents, skills, platform and runtime specifications
pnpm test        # contract and architecture checks
```

Then read, in this order: [`AGENTS.md`](AGENTS.md) for the rules, [`domains/tunisia-dtc/domain.yaml`](domains/tunisia-dtc/domain.yaml) for what a domain looks like, and [`templates/domain-pack/README.md`](templates/domain-pack/README.md) for building your own.

To look at the runtime:

```bash
pnpm runtime:up       # n8n on http://localhost:5678, with its own PostgreSQL
pnpm runtime:health
pnpm runtime:down
```

The local stack starts n8n and the database it uses for itself. Importing the workflows and provisioning the domain database are not wired up yet, so what you get is an empty n8n, not a working agent.

## Installation

**Requirements**

| Tool | Version | Notes |
|---|---|---|
| Node.js | 22.x exactly | `.npmrc` sets `engine-strict=true`, so installing on another version fails |
| pnpm | 10.15.0 | `corepack enable` then `corepack prepare pnpm@10.15.0 --activate` |
| Docker | Any current version | Needed for the local runtime and `pnpm db:verify` |
| Git Bash | Windows only | Many scripts are bash; Git Bash also avoids Node picking up WSL's bash |

```bash
corepack enable
pnpm install
pnpm run doctor
```

**Database.** Migrations are applied with Drizzle:

```bash
export DATABASE_URL=postgres://user:password@host:5432/database
# export DATABASE_PROFILE=supabase   # only on Supabase
pnpm db:migrate
```

`pnpm db:verify` applies the migrations to a throwaway PostgreSQL in Docker and checks that audit records cannot be changed, that the idempotency gate behaves, and that row level security covers every table.

Environment examples are in [`infrastructure/environments/`](infrastructure/environments/).

## Development

```bash
pnpm build        # TypeScript type check
pnpm validate     # specifications, contracts and domain packs
pnpm test         # the full check suite
pnpm run doctor       # environment check
```

Database work:

```bash
pnpm db:generate  # migration from the Drizzle schema
pnpm db:check     # migration tree consistency
pnpm db:migrate   # apply
pnpm db:verify    # apply and verify on throwaway PostgreSQL (Docker)
```

Through the harness, which currently wraps the same scripts:

```bash
pnpm harness doctor
pnpm harness validate
pnpm harness test
```

Conventions, branch and commit rules: [`CONTRIBUTING.md`](CONTRIBUTING.md). Guides for extending the framework: [`documentation/development/`](documentation/development/).

## Testing

`pnpm test` runs one TypeScript assertion test and about 40 repository checks, and skips three checks that need a live runtime, naming each one.

Be clear about what that does and does not prove. Most checks confirm that specifications, contracts and workflow definitions exist and agree with each other. They do not execute a workflow, call a provider or exercise the database. A green suite means the repository is internally consistent, not that the agent works.

| Suite | Checks |
|---|---|
| `tests/architecture/` | Structure and architecture rules |
| `tests/platform/`, `tests/production/` | Platform and production contracts |
| `tests/security/`, `tests/red-team/` | Security contracts and the red-team matrix |
| `tests/integration/`, `tests/e2e/` | Scenario definitions, pending a live runtime |
| `platform/state/db/tests/` | pgTAP suites, run by `pnpm db:verify` |

## Deployment

**Not available yet.** The compose files, environment examples and deployment specifications exist, but `scripts/production/` mostly prints what a deployment would do. There is no deployment workflow, no TLS in the proxy configuration, and no monitoring.

What exists: compose files for local, staging and production in [`infrastructure/docker/`](infrastructure/docker/); environment examples; backup and restore scripts that do real work (`pnpm backup:create`, `backup:verify`, `backup:restore`); and the release and certification specifications in [`spec/releases/`](spec/releases/).

The intended path is described in [`documentation/deployment/`](documentation/deployment/). Treat it as a design, not instructions.

## Operations

Also not available yet. The `ops:*` scripts are placeholders, `runtime/monitoring/` is empty, and the evidence folders under `runtime/evidence/` record structure rather than results.

The design is worth knowing, because the workflows are built for it: WF-19 handles maintenance, monitoring and reconciliation; unknown outcomes are reconciled before retry; and certification only passes on real evidence, which is why every gate currently reports `NOT_EXECUTED` rather than a guess.

## Documentation

| Tree | Audience | Published |
|---|---|---|
| [`documentation/`](documentation/) | Reference for users and developers | Yes |
| `docs/` | Internal engineering notes, security material and runbooks | No, and not in clones |

Start with [`documentation/getting-started/`](documentation/getting-started/) and [`documentation/development/`](documentation/development/).

## Roadmap

In order, because each step depends on the one before it:

1. **Make the repository honest and consistent.** Checks pass, one home per concept, documentation matches the code. Largely done.
2. **A runtime that starts from a clean clone.** One command brings up n8n and the domain database, applies migrations and imports the workflows.
3. **A read-only slice.** A signed inbound message produces a correct answer with an audit record; a forged one is rejected.
4. **Safe business actions.** WF-10 stores an authorization, WF-20 verifies it, idempotency and reconciliation are wired in, and the boundary tests pass.
5. **Staging with real evidence.** The gates that currently report `NOT_EXECUTED` produce real results.
6. **Production readiness.** Working deployment, rehearsed rollback and restore, certification from real evidence.
7. **Platform expansion.** Further adapters, a second domain, and the harness control plane.

[`ROADMAP.md`](ROADMAP.md) carries the detail. It predates this plan in places and is being rewritten against it.

## Project status

**Early development. Do not deploy this.**

| Area | State |
|---|---|
| Domain model, contracts, specifications | Complete for the reference domain, and validated |
| Database schema and migrations | Implemented, provider-neutral, verifiable with Docker |
| Workflows | All 21 of the reference domain's are placeholders; earlier full versions are reference material only |
| Authorization boundary | Enforced in platform code ([`platform/authorization/port.ts`](platform/authorization/port.ts), behaviourally tested); not yet wired into the n8n graphs |
| Webhook signature verification | Implemented (HMAC-SHA256 over the raw body, verified before normalisation; not yet exercised against Meta) |
| Adapters (Messenger, WooCommerce) | Contracts only |
| Deployment and operations | Placeholder scripts |
| Harness control plane | Three working commands; the rest is specified |
| Tests | Mostly repository contract checks; the webhook and authorization boundaries have behavioural unit tests |
| End-to-end run | Never performed |

The release line is being reconciled: `package.json` says 0.13.3 while parts of the documentation and the archived releases refer to 0.20.3. The badge above follows `package.json` until that is settled.

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md). Read [`AGENTS.md`](AGENTS.md) first: it applies to human and AI contributors alike.

## Security

Report vulnerabilities as described in [`SECURITY.md`](SECURITY.md). Please do not open public issues for them. The known gaps listed under [Security model](#security-model) are already tracked.

## Governance

Decision-making and maintainership: [`GOVERNANCE.md`](GOVERNANCE.md).

## Code of Conduct

[`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md) applies to every project space.

## Support

Questions and help: [`SUPPORT.md`](SUPPORT.md).

## Changelog

Release history: [`CHANGELOG.md`](CHANGELOG.md). Archived release packages are listed in [`RELEASE-ARCHIVE-INDEX.md`](RELEASE-ARCHIVE-INDEX.md).

## License

Apache-2.0. See [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE). Third-party components are listed in [`THIRD-PARTY.md`](THIRD-PARTY.md).

## Acknowledgements

Built on [n8n](https://n8n.io) for workflow orchestration, PostgreSQL with [pgvector](https://github.com/pgvector/pgvector) for durable state and retrieval, and [Drizzle ORM](https://orm.drizzle.team) for the schema and migrations.
