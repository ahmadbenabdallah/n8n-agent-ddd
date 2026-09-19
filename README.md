# n8n Agent DDD

**Open-source, domain-driven autonomous agent runtime built around n8n.**

[![Status](https://img.shields.io/badge/status-active%20development-orange)](#project-status)
[![Version](https://img.shields.io/badge/version-0.20.3-blue)](#release-line)
[![License](https://img.shields.io/badge/license-Apache--2.0-green)](#license)

n8n Agent DDD is an open-source platform for building **domain-driven autonomous business agents** around n8n.

It combines:

- domain-driven design
- deterministic workflow orchestration
- LLM reasoning
- explicit authorization boundaries
- durable application state
- channel and commerce adapters
- knowledge and retrieval
- audit and reconciliation
- production deployment controls
- an AI-native software development lifecycle
- a developer/AI control plane called **Harness**

The first concrete reference implementation is a **Tunisia DTC e-commerce AI Sales & Support Assistant**.


## Start here

If you are new to the project, **do not start by reading the whole architecture**.

Use this path:

```text
1. Clone the repository
2. Install Node.js + pnpm + Docker
3. Run the local doctor
4. Run repository validation/tests
5. Start the local n8n runtime
6. Open n8n at http://localhost:5678
7. Open the repository with Claude Code or Codex
8. Let the coding agent read AGENTS.md / CLAUDE.md
9. Use the Harness commands for plan → test → validate
10. Deep-dive into DDD, workflows, security and deployment
```

There are **two things you are starting**:

| Layer | What it is | Where you work |
|---|---|---|
| Repository / engineering layer | Specs, domain model, contracts, tests, Harness and AI-SDLC | Your local terminal + Git |
| Agent runtime | n8n workflows, durable state, LLM and provider adapters | Docker + n8n |

You can work on the repository without running n8n. You can also start n8n locally to inspect the runtime. A local runtime is **development infrastructure, not production certification**.

### The shortest successful first session

```bash
git clone <repository-url>
cd n8n-agent-ddd

corepack enable
corepack prepare pnpm@10.15.0 --activate

pnpm install

pnpm doctor
pnpm validate
pnpm test
```

Then start the local runtime:

```bash
cp infrastructure/environments/local/.env.example \
   infrastructure/environments/local/.env

docker compose \
  -f infrastructure/docker/docker-compose.local.yml \
  up -d
```

Open:

```text
http://localhost:5678
```

Then open another terminal and start your coding agent:

```bash
claude
```

or:

```bash
codex
```

The repository is designed so the AI coding agent reads the repository instructions before changing code. **Do not give an AI coding agent production SSH access.**

> **Current implementation note:** the local Docker compose file is the runtime scaffold for n8n (and optional Redis queue mode). It does not by itself provision the complete production PostgreSQL/Supabase data plane. Treat the local runtime as a development/integration starting point and follow the environment-specific documentation before attempting a full domain E2E setup.

> **LLM proposes → n8n validates → WF-10 authorizes → WF-20 executes → commerce provider verifies → WF-16 renders → WF-17 audits → WF-19 monitors.**

---

## Table of Contents

### Start / onboarding
- [Start here](#start-here)
- [Choose your development path](#choose-your-development-path)
- [Prerequisites](#prerequisites)
- [Local installation](#local-installation)
- [Start the local n8n runtime](#start-the-local-n8n-runtime)
- [First 15 minutes](#first-15-minutes)
- [Run with Claude Code](#run-with-claude-code)
- [Run with Codex](#run-with-codex)
- [Future OpenCode integration](#future-opencode-integration)

### Understand the system
- [What is n8n Agent DDD?](#what-is-n8n-agent-ddd)
- [How the pieces fit together](#how-the-pieces-fit-together)
- [Why it exists](#why-it-exists)
- [Core principles and invariants](#core-principles-and-invariants)
- [Architecture](#architecture)
- [Repository structure](#repository-structure)
- [Tunisia DTC reference implementation](#tunisia-dtc-reference-implementation)
- [The 21-workflow architecture](#the-21-workflow-architecture)
- [Domain-driven design](#domain-driven-design)
- [Security model](#security-model)
- [Multi-channel and multi-commerce](#multi-channel-and-multi-commerce)
- [Harness and AI-SDLC](#harness-and-ai-sdlc)
- [State, idempotency and reconciliation](#state-idempotency-and-reconciliation)

### Build / operate
- [Configuration](#configuration)
- [Daily developer workflow](#daily-developer-workflow)
- [Testing and evidence](#testing-and-evidence)
- [Deployment and operations](#deployment-and-operations)
- [Deep-dive reading map](#deep-dive-reading-map)
- [Documentation and ReadMe](#documentation-and-readme)

### Project
- [Release line and roadmap](#release-line-and-roadmap)
- [Contributing](#contributing)
- [Security](#security)
- [Governance](#governance)
- [Code of Conduct](#code-of-conduct)
- [Support](#support)
- [Changelog](#changelog)
- [License](#license)
- [Acknowledgements](#acknowledgements)

---

## What is n8n Agent DDD?

n8n Agent DDD is designed around a simple separation of responsibilities:

```text
                    Developer / AI Agent
                            │
                     Claude / Codex
                            │
                      Skills + MCP
                            │
                            ▼
                       ┌─────────┐
                       │ Harness │
                       └────┬────┘
                            │
                     Git / CI / Gates
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                       n8n Agent DDD                          │
│                                                             │
│  Contracts · Platform · Domains · Policies · Tests          │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
                         ┌───────────┐
                         │    n8n    │
                         │  Runtime  │
                         └─────┬─────┘
                               │
             ┌─────────────────┼─────────────────┐
             ▼                 ▼                 ▼
        PostgreSQL/           LLM          External adapters
        Supabase                         Commerce / Channels
```

The project deliberately separates the **customer runtime** from the **developer/AI control plane**.

### Customer runtime

The deployed business agent consists of:

- n8n workflows
- domain rules and policies
- LLM reasoning
- channel adapters
- commerce adapters
- PostgreSQL/Supabase-backed durable state
- knowledge
- authorization
- audit
- reconciliation
- monitoring

### Developer/AI control plane

Harness is used by developers and AI coding agents such as Claude Code and Codex to:

- inspect the repository
- plan work
- implement changes
- run tests
- run security checks
- validate architecture
- manage worktrees
- prepare releases
- deploy through controlled gates
- operate and verify the runtime

**Harness is not the customer-facing agent runtime and does not replace n8n's native workflow dashboard.**

---

## Why it exists

Many AI-agent implementations reduce the system to:

```text
LLM + prompt + tools
```

That model becomes fragile when the agent must perform real business operations.

A production business agent also needs explicit answers to:

- Who is this customer?
- What data is this customer allowed to access?
- Which business action is actually authorized?
- Where does current product/price/stock truth come from?
- What happens when an external API times out after a mutation?
- How do we prevent duplicate orders?
- How do we reconcile unknown outcomes?
- How do we audit consequential actions?
- How do we deploy and roll back safely?
- How do we isolate domains?
- How do AI coding agents modify the system without bypassing controls?

n8n Agent DDD treats those concerns as **architecture and contracts**, not as prompt instructions alone.

---

# Core principles and invariants

### 1. Compute is disposable. State is durable.

n8n is the orchestration/runtime layer. Critical business state belongs in durable PostgreSQL/Supabase-backed storage.

### 2. The LLM is not an authorization system.

The LLM can reason and propose structured actions. It cannot authorize itself.

### 3. WF-10 is the hard commerce authorization boundary.

Only the authorized branch may establish that a consequential commerce action is permitted.

### 4. WF-20 is the privileged commerce boundary.

Commerce mutations are executed through the controlled commerce gateway and verified against the provider.

### 5. Order creation is not payment.

Creating an order does not imply that payment succeeded. For example, a newly created COD order remains `not_paid` until the actual payment state changes.

### 6. Unknown outcomes are reconciled.

If an external mutation times out after execution may have started, the system does not blindly retry. It reconciles the external state.

### 7. Identity cannot be promoted by the LLM.

Identity assurance is established by application logic:

```text
ANONYMOUS
  ↓
CHANNEL-LINKED
  ↓
COMMERCE-MATCHED
  ↓
ORDER-VERIFIED
  ↓
HIGH-ASSURANCE
```

### 8. Capability discovery is not authorization.

MCP visibility, tool discovery, workflow access or skill availability does not grant business permission.

### 9. Human ownership blocks conflicting automation.

When a human operator owns a case or action, conflicting autonomous execution is blocked.

### 10. Deployments are reversible.

Database migrations, runtime changes and traffic switches require verification and a rollback strategy.

### 11. Evidence determines maturity.

A repository contract is not the same thing as a live runtime test. Production certification requires captured runtime evidence.

---

# Architecture

The platform is organized into reusable layers.

```text
┌───────────────────────────────────────────────────────────┐
│                       AI / Developer                      │
│                 Claude Code · Codex · Agents              │
└───────────────────────────┬───────────────────────────────┘
                            │
                     Skills / MCP / Git
                            │
                            ▼
┌───────────────────────────────────────────────────────────┐
│                         Harness                           │
│  Planning · Tasks · Worktrees · Gates · Validation        │
└───────────────────────────┬───────────────────────────────┘
                            │
                            ▼
┌───────────────────────────────────────────────────────────┐
│                    Platform Contracts                      │
│ Identity · Authorization · State · Events · Audit         │
│ Reconciliation · Observability · Domain Isolation         │
└───────────────────────────┬───────────────────────────────┘
                            │
                            ▼
┌───────────────────────────────────────────────────────────┐
│                         Domain                            │
│ Entities · Aggregates · Policies · Commands · Events      │
│ Projections · Workflows · Knowledge · Adapters             │
└───────────────────────────┬───────────────────────────────┘
                            │
                            ▼
┌───────────────────────────────────────────────────────────┐
│                         n8n Runtime                        │
│                     Workflow orchestration                 │
└───────────────────────────┬───────────────────────────────┘
                            │
             ┌──────────────┼──────────────┐
             ▼              ▼              ▼
        PostgreSQL          LLM       External providers
        / Supabase                    Commerce / Channels
```

### Runtime execution boundary

```text
Customer
   ↓
Channel
   ↓
WF-00 Inbound Gateway
   ↓
WF-01 Security Gate
   ↓
WF-02 Identity
   ↓
WF-03 Conversation State
   ↓
WF-04 Intent Router
   ↓
Sales / Support
   ↓
WF-09 LLM Reasoning
   ↓
WF-10 Action Authorization
   ↓
WF-20 Privileged Commerce Gateway
   ↓
Commerce Provider
   ↓
WF-16 Response Renderer
   ↓
WF-17 Audit
   ↓
WF-19 Monitoring / Reconciliation
```

---

# Repository structure

The main repository is the **engine and engineering source repository**.

```text
n8n-agent-ddd/
│
├── spec/                 # Formal platform, domain, lifecycle and release contracts
│
├── .agents/              # Shared agent skills, policies, references and workflows
│
├── codex/                # Codex roles, commands and configuration
│
├── claude/               # Claude agents, commands and hooks
│
├── harness/              # Developer/AI control plane
│
├── platform/             # Reusable runtime/platform capabilities
│
├── domains/              # Business domain packs
│   └── tunisia-dtc/      # Reference domain
│
├── contracts/            # Platform/domain/action/event/external contracts
│
├── runtime/              # n8n, PostgreSQL/Supabase, monitoring and evidence
│
├── infrastructure/       # Docker, environments, deployment and backups
│
├── tests/                # Architecture, integration, security, DR, E2E, etc.
│
├── scripts/              # Bootstrap, validation, migration and operations
│
├── docs/                 # Internal engineering documentation
│
└── documentation/        # Curated public documentation snapshot/bridge
```

### Internal vs public documentation

```text
docs/
└── Internal
    architecture
    security procedures
    operational runbooks
    evidence procedures
    engineering notes

documentation/
└── Public
    getting started
    installation
    configuration
    development
    deployment
    operations
```

The dedicated `n8n-agent-ddd-docs` repository is the public Git endpoint intended for ReadMe bi-directional synchronization.

---

# Tunisia DTC reference implementation

The first concrete domain is a **Tunisia DTC e-commerce AI Sales & Support Assistant**.

It demonstrates how the platform handles:

- customer conversations
- Tunisian Arabic / Tounsi
- Arabic, French and English
- mixed Tounsi/French/English
- Latin-transliterated Arabic
- product discovery
- product recommendations
- sales objections
- cart assistance
- checkout
- COD orders
- order support
- promotions
- knowledge retrieval
- human escalation
- identity and privacy
- authorized commerce actions
- audit and reconciliation

A typical deployment can connect:

```text
Customer
   │
   ▼
WhatsApp / Instagram / Facebook / Webchat
   │
   ▼
n8n Agent Runtime
   │
   ├── PostgreSQL / Supabase
   ├── LLM provider
   ├── Knowledge base
   └── Commerce adapter
           │
           ▼
       WooCommerce
```

The Tunisia DTC implementation is a **reference domain**, not a restriction on the platform. The multi-domain architecture is intended to support additional domain packs such as Umrah, dental and other business domains.

---

# The 21-workflow architecture

The 21 workflows are the reference runtime architecture for the **Tunisia DTC AI Sales & Support Assistant**.

They demonstrate how a real business agent can separate inbound handling, security, identity, conversation state, reasoning, authorization, commerce execution, response rendering and operations.

| ID | Workflow | Tunisia DTC responsibility |
|---|---|---|
| WF-00 | Inbound Gateway | Receive and normalize customer/channel events |
| WF-01 | Security Gate | Apply deterministic security and input controls |
| WF-02 | Customer Identity | Resolve and maintain customer identity context |
| WF-03 | Conversation State | Maintain durable conversation state |
| WF-04 | Intent Router | Route sales, support, order and other intents |
| WF-05 | Sales Engine | Product discovery, recommendations and sales flows |
| WF-06 | Support Engine | Customer support and issue-resolution flows |
| WF-07 | Order Service | Authorized order retrieval and operations |
| WF-08 | Escalation Engine | Human handoff and ownership transitions |
| WF-09 | LLM Reasoning | Produce grounded reasoning and structured proposals |
| WF-10 | Action Authorization | Enforce the hard authorization boundary |
| WF-11 | Product Service | Product/catalog retrieval |
| WF-12 | Cart Service | Cart reads and authorized cart mutations |
| WF-13 | Promotion Service | Validate and apply promotion rules |
| WF-14 | Checkout Service | Checkout preparation and orchestration |
| WF-15 | Transaction / Payment | Transaction state and payment handling |
| WF-16 | Response Renderer | Render verified results for the customer |
| WF-17 | Audit & Analytics | Record auditable business/security events |
| WF-18 | Knowledge Base | Ingest and maintain approved knowledge |
| WF-19 | Maintenance & Monitoring | Health, reconciliation and operational control loop |
| WF-20 | WooCommerce Gateway | Privileged WooCommerce integration boundary |

### The critical execution invariant

```text
LLM proposes
    ↓
n8n validates
    ↓
WF-10 authorizes
    ↓
WF-20 executes
    ↓
WooCommerce verifies
    ↓
WF-16 renders verified facts
    ↓
WF-17 audits
    ↓
WF-19 monitors and reconciles
```

The LLM cannot directly execute commerce mutations, set final prices, change inventory, declare payment success, bypass authorization or access arbitrary endpoints.

---

# Domain-driven design

The platform separates business logic from infrastructure and provider-specific implementation.

```text
Domain
  ↓
Platform contracts
  ↓
Ports
  ↓
Adapters
  ↓
Infrastructure
```

A domain pack can contain:

```text
domain/
├── business/
├── entities/
├── aggregates/
├── value-objects/
├── commands/
├── events/
├── policies/
├── projections/
├── workflows/
├── knowledge/
├── adapters/
└── tests/
```

Provider-specific IDs are references, not domain identity. Provider-specific credentials and implementation details remain inside adapters.

---

# Security model

Security is an architectural property, not a prompt-only feature.

## Authorization

```text
LLM proposal
      ↓
n8n validation
      ↓
WF-10 authorization
      ↓
authorized action
      ↓
WF-20 execution
      ↓
provider verification
```

Only the authorized branch may establish `execution_allowed=true`.

## Identity and privacy

The LLM cannot promote identity.

Order access is narrower than customer identity, and sensitive order/customer/payment data requires verified scope.

## Sensitive data

The following must never be placed into LLM or customer-visible context:

- PAN
- CVV
- OTP
- PIN
- passwords
- API keys
- provider secrets
- WooCommerce credentials/secrets
- cart tokens/nonces

Secrets are deployment-managed and excluded from:

- Git
- agent durable state
- prompts
- logs
- evidence artifacts
- doctor/status output
- customer messages

## Prompt injection

Customer messages, retrieved content, conversation history and external tool text are treated as untrusted unless explicitly designated as trusted structured data.

Retrieved content cannot override:

- system policy
- authorization
- identity scope
- security rules
- business rules

## High-risk escalation

Automation stops or escalates for cases such as:

- payment disputes or chargebacks
- legal threats
- serious unresolved complaints
- identity uncertainty for sensitive actions
- unauthorized-action requests
- security incidents
- repeated failed resolution
- human-owned cases

---

# Multi-channel and multi-commerce

Channels and commerce providers are independent axes.

```text
                 Domain
                   │
          ┌────────┴────────┐
          │                 │
       Channel           Commerce
          │                 │
     WhatsApp            WooCommerce
     Messenger            Shopify
     Instagram            PrestaShop
     Telegram             Custom
     Webchat
```

Core ports:

```text
ChannelPort
CommercePort
IdentityPort
PaymentPort
KnowledgePort
ObservabilityPort
```

This allows combinations such as:

```text
Messenger + WooCommerce
Messenger + Shopify
WhatsApp + Shopify
WhatsApp + PrestaShop
Telegram + Custom Commerce
Webchat + Shopify
```

The platform should not embed one provider into the domain model.

---

# Harness and AI-SDLC

Harness is the developer/AI control plane.

```text
Claude Code / Codex
        ↓
      Skills
        ↓
       MCP
        ↓
     Harness
        ↓
   Git / CI / Gates
        ↓
Runtime / n8n / infrastructure
```

The agent topology is:

```text
Chief
├── PM
├── Architect / CTO
├── Security
├── Developers
├── QA
└── Reviewer
```

The AI-SDLC lifecycle is:

```text
DISCOVER
→ DEFINE
→ DOMAIN
→ SPECIFY
→ ARCHITECT
→ DESIGN
→ DECOMPOSE
→ PLAN
→ IMPLEMENT
→ TEST
→ SECURITY
→ REVIEW
→ INTEGRATE
→ DEPLOY
→ VERIFY
→ OPERATE
→ LEARN
```

Agents use isolated worktrees and durable task state.

### Bounded autonomy

Agents may autonomously:

- inspect
- plan
- implement scoped changes
- run tests
- run security checks
- prepare releases
- propose improvements

High-impact actions remain review-gated, including:

- production deployment
- destructive migrations
- credential operations
- sensitive runtime changes
- authorization-policy changes

Agents must never:

- SSH directly into production
- bypass CI
- bypass WF-10
- silently weaken security
- access production secrets by default
- claim execution without evidence

---

# State, idempotency and reconciliation

Critical business state is durable.

Examples include:

```text
customer_identity
conversation
conversation_state
carts
cart_items
actions
authorizations
order_scope
orders
transactions
escalations
audit_events
idempotency_keys
knowledge
```

Consequential mutations require idempotency.

A mutation follows the conceptual lifecycle:

```text
REQUESTED
    ↓
AUTHORIZED
    ↓
EXECUTION_STARTED
    ↓
COMMERCE_MUTATION
    ↓
VERIFICATION
    ↓
COMPLETED
```

Unknown external outcomes require reconciliation rather than blind retry.

The operational control loop is:

```text
OBSERVE
→ CLASSIFY
→ DECIDE
→ ACT
→ VERIFY
→ AUDIT
→ LEARN
```

Self-healing is bounded. It may restart disposable workers, retry safe transient failures within limits, clear stale locks or reschedule reconciliation.

It may not authorize commerce, change prices/stock/payment state, bypass WF-10, or blindly retry an unknown mutation.

---

# Choose your development path

There are three distinct ways to work with this repository:

### Path A — Repository engineering only

Use this when you want to understand or modify the platform without starting n8n:

```bash
pnpm install
pnpm doctor
pnpm validate
pnpm test
pnpm build
```

This is the fastest path for contributors working on contracts, domain logic, policies, Harness, validation or documentation.

### Path B — Repository + local n8n

Use this when you want to inspect or develop the runtime:

```text
Repository
   │
   ├── Harness / tests / contracts
   │
   └── Docker Compose
          ├── n8n :5678
          └── Redis (optional queue profile)
```

This is the normal local development path for the project.

### Path C — Full integration environment

Use this when you need real database, channel, commerce and LLM integration:

```text
Channel
   ↓
n8n
   ↓
PostgreSQL / Supabase
   ↓
LLM provider
   ↓
Commerce adapter
   ↓
Audit / reconciliation
```

This requires provider credentials and environment-specific setup. Do not treat Path B as equivalent to a production-like integration environment.

---

# Prerequisites

## Required for repository development

- Git
- Bash-compatible shell
- Node.js **22.x**
- pnpm **10.15.0** (the repository pins this package manager)
- Docker
- Docker Compose

Verify:

```bash
git --version
node --version
pnpm --version
docker --version
docker compose version
```

The repository currently declares:

```text
Node.js >=22 <23
pnpm 10.15.0
```

## Required for AI-assisted development

At least one coding agent:

- Claude Code
- Codex CLI

OpenCode is a planned additional adapter; see [Future OpenCode integration](#future-opencode-integration).

---

# Local installation

## 1. Clone

```bash
git clone <repository-url>
cd n8n-agent-ddd
```

If you are contributing, create a branch before making changes:

```bash
git checkout -b feature/my-change
```

## 2. Install JavaScript/TypeScript dependencies

```bash
corepack enable
corepack prepare pnpm@10.15.0 --activate
pnpm install
```

## 3. Run the project doctor

```bash
pnpm doctor
```

The doctor checks the local engineering prerequisites and repository control-plane files such as:

- `AGENTS.md`
- `CLAUDE.md`
- Codex adapter configuration
- shared skills
- Harness
- platform
- domain
- runtime directories

A successful doctor result means the **repository environment** is ready. It does not mean the customer runtime is ready.

## 4. Validate the repository

```bash
pnpm validate
pnpm test
pnpm build
```

For the broader architecture checks:

```bash
pnpm test:architecture:db
pnpm test:architecture:capabilities
pnpm test:architecture:upstream-skills
```

---

# Start the local n8n runtime

The repository includes a local Docker Compose runtime scaffold at:

```text
infrastructure/docker/docker-compose.local.yml
```

### 1. Create local environment configuration

```bash
cp infrastructure/environments/local/.env.example \
   infrastructure/environments/local/.env
```

Edit the file only if you need provider integrations.

Typical variables include:

```text
N8N_HOST
N8N_PORT
N8N_PROTOCOL

SUPABASE_URL
SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY

OPENAI_API_KEY

WOOCOMMERCE_URL
WOOCOMMERCE_CONSUMER_KEY
WOOCOMMERCE_CONSUMER_SECRET

META_VERIFY_TOKEN
META_APP_SECRET
META_PAGE_ACCESS_TOKEN
```

**Never commit real credentials.**

### 2. Start n8n

```bash
docker compose \
  -f infrastructure/docker/docker-compose.local.yml \
  up -d
```

Check:

```bash
docker compose \
  -f infrastructure/docker/docker-compose.local.yml \
  ps
```

View logs:

```bash
docker compose \
  -f infrastructure/docker/docker-compose.local.yml \
  logs -f n8n
```

Open:

```text
http://localhost:5678
```

### 3. Stop the runtime

```bash
docker compose \
  -f infrastructure/docker/docker-compose.local.yml \
  down
```

To remove the local named volumes as well:

```bash
docker compose \
  -f infrastructure/docker/docker-compose.local.yml \
  down -v
```

Use `down -v` carefully because it removes local persisted container data.

### 4. Optional Redis queue profile

Redis is defined as an optional Compose profile:

```bash
docker compose \
  -f infrastructure/docker/docker-compose.local.yml \
  --profile queue \
  up -d
```

Redis is not the durable business-state source of truth.

---

# First 15 minutes

After installation, follow this exact sequence.

### Minute 1–3 — Prove the repository works

```bash
pnpm doctor
pnpm validate
pnpm test
```

### Minute 3–5 — Understand the control files

Read these first:

```text
AGENTS.md
CLAUDE.md
codex/AGENTS.md
agent-manifest.yaml
```

Then:

```text
harness/README.md
docs/agents/README.md
docs/architecture/repository-final-model.md
```

### Minute 5–8 — Understand the runtime

Read:

```text
runtime/README.md
runtime/n8n/README.md
infrastructure/docker/README.md
domains/tunisia-dtc/README.md
```

Then inspect:

```text
domains/tunisia-dtc/
contracts/
platform/
```

### Minute 8–12 — Understand the customer-agent flow

Start with:

```text
WF-00 → WF-01 → WF-02 → WF-03 → WF-04
                           ↓
                     Sales / Support
                           ↓
                         WF-09
                           ↓
                         WF-10
                           ↓
                         WF-20
                           ↓
                         WF-16
                           ↓
                         WF-17
                           ↓
                         WF-19
```

The important mental model is:

```text
input
→ security
→ identity
→ state
→ intent
→ reasoning
→ authorization
→ execution
→ verification
→ response
→ audit
→ monitoring
```

### Minute 12–15 — Ask an AI coding agent to explain before changing anything

Claude Code example:

```text
Read AGENTS.md and CLAUDE.md first.
Do not modify files.

Explain:
1. what this repository is,
2. how the Harness differs from the customer runtime,
3. how the Tunisia DTC domain is structured,
4. where WF-10 and WF-20 fit,
5. which files I should read next.
```

This is intentionally a **read-only orientation step**.

---

# Run with Claude Code

Claude Code is the primary Claude-family developer adapter documented by this project.

Current official Claude Code installation methods include the native installer, Homebrew and WinGet. On macOS/Linux/WSL, the native installer is:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Then verify and start:

```bash
claude --version
cd /path/to/n8n-agent-ddd
claude
```

On first use, Claude Code prompts for authentication unless an accepted API-key setup is already configured.

### Why this repository works well with Claude Code

The repository provides:

```text
CLAUDE.md
AGENTS.md
.agents/
claude/
harness/
spec/
```

The intended flow is:

```text
Claude Code
    ↓
AGENTS.md / CLAUDE.md
    ↓
shared skills
    ↓
Harness
    ↓
task / architecture gates
    ↓
Git branch / worktree
    ↓
tests + security + validation
    ↓
PR
```

### First Claude Code session

Start conservatively:

```bash
cd n8n-agent-ddd
claude
```

Ask:

```text
Read AGENTS.md and CLAUDE.md.

Do not edit anything yet.

Give me:
- repository architecture
- current lifecycle
- relevant skills
- relevant Harness commands
- the smallest safe task I can implement first
```

Then, for an actual task:

```text
Plan this task first.

Do not modify production infrastructure.
Do not bypass Harness validation.
Do not change WF-10 or WF-20 without identifying the security implications.

Inspect the relevant contracts and tests, propose the smallest implementation,
then wait for approval before editing.
```

Claude Code supports project instructions through `CLAUDE.md`; this repository uses that file together with the shared `AGENTS.md` and `.agents/skills/` system.

---

# Run with Codex

Codex is the second first-class developer adapter.

Install the Codex CLI using the current official installer:

```bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

Then:

```bash
cd /path/to/n8n-agent-ddd
codex
```

Authenticate when prompted.

The repository gives Codex the same engineering source of truth:

```text
AGENTS.md
.agents/skills/
codex/
harness/
spec/
```

The Codex adapter should **not create a separate architecture or security policy**. Its job is to translate the shared repository contract into Codex-specific roles/configuration.

### First Codex session

Start with:

```text
Read AGENTS.md and codex/AGENTS.md.

Do not modify files.

Explain the repository architecture and identify the correct Harness
commands for planning, validation and testing.
```

Then use the same lifecycle:

```text
PLAN
→ SPEC
→ IMPLEMENT
→ TEST
→ SECURITY
→ VALIDATE
→ REVIEW
→ MERGE
```

---

# Future OpenCode integration

OpenCode is planned as an additional developer-agent adapter.

The architectural goal is:

```text
                Shared repository contract
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
      Claude Code      Codex        OpenCode
          │              │              │
          └──────────────┼──────────────┘
                         ▼
                      Harness
                         │
               shared skills / policies
                         │
                    Git + CI gates
```

OpenCode is **not intended to introduce a third set of business rules**.

When the adapter is implemented, it should consume the same:

```text
AGENTS.md
spec/
.agents/skills/
.agents/policies/
harness/
contracts/
```

and map its agent/permission model to the same Harness lifecycle.

OpenCode's current documentation provides terminal, desktop and IDE workflows and supports project-level `AGENTS.md`; this project will use that compatibility rather than creating an OpenCode-specific architecture.

**Until the adapter is committed and tested in this repository, treat OpenCode support as planned rather than available.**

---

# How the developer tools relate to each other

This distinction is critical.

```text
┌─────────────────────────────────────────────────────┐
│              AI coding interface                    │
│                                                     │
│  Claude Code       Codex       Future: OpenCode     │
└───────────────────────┬─────────────────────────────┘
                        │
                        ▼
                 Shared instructions
              AGENTS.md / skills / spec
                        │
                        ▼
                    Harness
        plan / test / security / validate / deploy
                        │
                        ▼
                 Git + CI + gates
                        │
                        ▼
              Customer runtime artifact
                        │
                        ▼
                       n8n
```

**Do not confuse this with the runtime agent:**

```text
Customer message
      ↓
n8n Agent DDD runtime
      ↓
LLM reasoning
      ↓
WF-10 authorization
      ↓
WF-20 commerce execution
```

Claude Code, Codex and future OpenCode are **development agents**.

The n8n-based system is the **deployed business agent**.

Harness is the **control plane between engineering agents and the governed repository/runtime lifecycle**.

---

# Harness: the normal developer interface

After the repository is installed, the intended command surface is:

```bash
pnpm harness doctor
pnpm harness validate
```

The repository also defines the target Harness command model:

```bash
harness init
harness doctor
harness install
harness configure
harness develop
harness plan
harness test
harness security
harness validate
harness deploy
harness upgrade
harness rollback
harness status
harness run
```

Not every command is equally implemented in every release. Treat the repository's actual CLI and scripts as authoritative for the current release.

The Harness lifecycle is:

```text
PLANNED
   ↓
ANALYZING
   ↓
SPEC_READY
   ↓
IMPLEMENTING
   ↓
TESTING
   ↓
SECURITY_REVIEW
   ↓
ARCHITECTURE_REVIEW
   ↓
READY_FOR_REVIEW
   ↓
APPROVED
   ↓
MERGED
   ↓
DEPLOYED
   ↓
VERIFIED
   ↓
OPERATE
```

---

# Configuration

Configuration is deliberately separated into three classes.

### Repository configuration

Safe to version:

```text
spec/
contracts/
domain definitions
workflow contracts
policies
agent roles
skills
non-secret runtime defaults
```

### Runtime configuration

Provided to the environment:

```text
database URLs
provider URLs
feature flags
runtime endpoints
non-secret deployment configuration
```

### Secrets

Never commit:

```text
API keys
OAuth secrets
WooCommerce consumer secrets
Meta app secrets
LLM API keys
database passwords
private signing material
customer payment credentials
```

Use the runtime's secret mechanism or deployment secret store.

The local example file is:

```text
infrastructure/environments/local/.env.example
```

Copy it to `.env` locally and keep the real file out of Git.

---

# Daily developer workflow

A good first implementation loop is:

```text
1. Pull latest main
2. Create feature branch
3. Ask the AI coding agent to inspect the relevant area
4. Read the applicable spec/contract
5. Plan the change
6. Implement the smallest safe change
7. Run focused tests
8. Run architecture/security validation
9. Review the diff
10. Run the full repository validation
11. Commit
12. Open PR
```

Typical commands:

```bash
git status
git checkout -b feature/example

pnpm doctor
pnpm validate
pnpm test

git diff
git status
```

For database-related changes:

```bash
pnpm db:check
pnpm db:validate
pnpm test:db:contract
pnpm test:architecture:db
```

For capability/control-plane changes:

```bash
pnpm test:architecture:capabilities
pnpm test:architecture:upstream-skills
```

For operations:

```bash
pnpm ops:health
pnpm ops:drift
pnpm ops:reconcile
pnpm ops:self-heal
pnpm ops:cost
```

---

# Deep-dive reading map

Once the first local session works, do not read the repository randomly.

Follow this order.

### Level 1 — Product mental model

```text
README.md
ROADMAP.md
ARCHITECTURE.md
```

Understand:

- what the project is
- why n8n is used
- why DDD is used
- runtime vs Harness
- domain vs platform
- current maturity

### Level 2 — AI development model

```text
AGENTS.md
CLAUDE.md
codex/AGENTS.md
docs/agents/README.md
docs/agents/AI-SDLC.md
docs/agents/AGENT-EXECUTION.md
```

Understand:

- agent roles
- lifecycle
- skills
- task graph
- worktrees
- review
- bounded autonomy

### Level 3 — Platform architecture

```text
platform/
contracts/platform/
docs/architecture/
```

Start with:

```text
docs/architecture/repository-final-model.md
docs/architecture/multi-channel-multi-commerce.md
docs/architecture/capability-control-plane.md
docs/architecture/openclaw-influenced-runtime.md
```

### Level 4 — Domain model

```text
domains/tunisia-dtc/
contracts/domain/tunisia-dtc.yaml
docs/domain/
```

Understand:

- entities
- aggregates
- commands
- events
- policies
- projections
- workflows
- adapters

### Level 5 — Runtime

```text
runtime/
infrastructure/docker/
```

Then inspect the workflow contracts and runtime bindings.

### Level 6 — Security

```text
SECURITY.md
docs/security/
contracts/platform/authorization.yaml
platform/authorization/
```

Then study the red-team and production evidence material.

### Level 7 — Operations

```text
docs/operations/
scripts/operations/
scripts/production/
infrastructure/deployment/
```

Only after understanding the previous levels should you study production promotion, blue/green deployment, rollback, reconciliation and self-healing.

---

# What to build first

If you are starting implementation from scratch, do **not** begin by trying to make all 21 workflows autonomous.

Build vertically.

### Step 1 — Repository contract

Make sure:

```bash
pnpm doctor
pnpm validate
pnpm test
```

work.

### Step 2 — Local runtime

Start n8n and prove that the local runtime is reachable.

### Step 3 — One domain slice

Implement one small end-to-end capability:

```text
Inbound
→ Security
→ Identity
→ State
→ Intent
→ Read-only product lookup
→ Response
→ Audit
```

### Step 4 — Add controlled mutation

Only then introduce:

```text
LLM proposal
→ WF-10 authorization
→ WF-20 execution
→ provider verification
→ response
→ audit
```

### Step 5 — Add resilience

Then add:

```text
idempotency
reconciliation
timeouts
retry budgets
dead-letter / escalation
drift detection
```

### Step 6 — Production lifecycle

Only after the runtime has evidence:

```text
staging
→ certification
→ backup
→ blue/green
→ traffic switch
→ rollback
→ operations
```

This vertical approach makes the architecture easier to understand and prevents the repository from becoming a collection of disconnected workflow files.

---

# Testing and evidence

Testing is organized into multiple levels:

```text
tests/
├── architecture/
├── certification/
├── disaster-recovery/
├── documentation/
├── harness/
├── integration/
├── operations/
├── platform/
├── production/
└── security/
```

The project distinguishes:

1. repository contract
2. local execution
3. staging execution
4. captured certification evidence
5. production verification

A passing contract test does **not** imply that a real staging or production runtime has passed.

The production certification framework covers areas including:

- runtime integration
- 21-workflow execution
- channel/commerce E2E
- security/red-team testing
- idempotency
- reconciliation
- load/resilience
- backup/restore
- blue/green deployment
- rollback
- drift detection
- bounded self-healing
- safety
- audit

---

# Deployment and operations

The release lifecycle is:

```text
PRECHECK
→ BACKUP
→ EXPAND
→ DEPLOY
→ MIGRATE
→ VERIFY
→ SWITCH
→ DRAIN
→ CONTRACT
→ AUDIT
```

Blue/green deployment:

```text
prepare green
    ↓
health checks
    ↓
smoke tests
    ↓
explicit traffic switch
    ↓
drain blue
    ↓
verify
    ↓
rollback remains available
```

Database changes prefer:

```text
EXPAND
→ MIGRATE
→ VERIFY
→ SWITCH
→ CONTRACT
```

Production deployment requires the relevant staging evidence, certification, operational preflight and explicit approval.

Coding agents do not SSH directly into production.

---

# Documentation and ReadMe

The project separates public and internal documentation.

```text
n8n-agent-ddd
│
├── docs/
│     └── internal engineering documentation
│
└── documentation/
      └── curated public documentation
              │
              ▼
      n8n-agent-ddd-docs
              ↕
      ReadMe bi-directional sync
```

The dedicated `n8n-agent-ddd-docs` repository is intended to be the public Git endpoint connected to ReadMe.

The main engine repository remains responsible for:

- code
- specifications
- workflows
- tests
- infrastructure
- internal documentation

The public documentation repository contains only documentation intended for external users and developers.

### ReadMe sync status

**0.20.3 prepares the repository architecture and migration path. It does not claim that a live GitHub ↔ ReadMe connection has already been executed.**

The initial ReadMe connection is a provider-side setup step. Once connected, ReadMe's Git Sync provides the bidirectional Git ↔ ReadMe relationship.

---

# Release line and roadmap

The project has evolved through the following major phases:

| Version | Focus |
|---|---|
| 0.1 | Foundation |
| 0.2 | AI-SDLC |
| 0.3 | Skills |
| 0.4 | DDD platform |
| 0.5 | n8n runtime |
| 0.6 | Tunisia DTC domain |
| 0.7 | Durable state |
| 0.8 | Supabase hardening |
| 0.9 | Staging integration |
| 0.10 | Multi-channel, data-plane and control-plane foundations |
| 0.11 | Production deployment foundation |
| 0.12 | Autonomous operations foundation |
| 0.13 | Provider-neutral runtime |
| 0.14 | Real-runtime integration foundation |
| 0.15 | Evidence and certification |
| 0.16 | Production operationalization |
| 0.17 | Harness Control Plane |
| 0.18 | Agent-Installable Platform |
| 0.19 | Autonomous AI-SDLC & Operations |
| 0.20 | Multi-Domain Platform / Ecosystem |
| 0.20.1 | Public/internal documentation split |
| 0.20.2 | Documentation audit and privacy boundary |
| 0.20.3 | ReadMe bi-directional documentation architecture |

### Current status

The 0.17–0.20 series establishes the architectural and operational foundation for the next maturity stage.

The project does **not** claim production certification solely because these repository phases exist.

The next maturity work is focused on:

- real runtime evidence
- staging execution
- operational validation
- certification
- deployment hardening
- ecosystem/domain-pack maturity
- eventual 1.0 stabilization

---


## Open-source project files

The repository maintains the standard public OSS governance and legal surface:

| File | Purpose |
|---|---|
| `LICENSE` | Apache License 2.0 terms |
| `NOTICE` | Project and third-party attribution notices |
| `CONTRIBUTING.md` | Contributor workflow and engineering expectations |
| `SECURITY.md` | Security policy and vulnerability handling |
| `GOVERNANCE.md` | Project governance and decision-making |
| `CODE_OF_CONDUCT.md` | Community participation standards |
| `SUPPORT.md` | Support and issue guidance |
| `CHANGELOG.md` | Release history and material changes |

These files are part of the public repository contract and should be kept synchronized with project behavior and release policy.

# Contributing

Contributions are welcome across:

- platform architecture
- domain packs
- n8n workflows
- adapters
- security
- testing
- infrastructure
- Harness
- AI-SDLC
- documentation

Before contributing:

1. Understand the relevant specification.
2. Identify affected domain/platform contracts.
3. Define acceptance criteria.
4. Implement the smallest coherent change.
5. Add or update tests.
6. Run security validation for security-sensitive changes.
7. Run architecture validation where boundaries are affected.
8. Update documentation when behavior changes.
9. Submit the change through normal Git review.

### Contribution principle

> **A feature is not complete when the code works locally. It is complete when its contracts, tests, security implications, documentation and operational behavior are understood.**

A dedicated `CONTRIBUTING.md` should be maintained as the canonical contributor guide before the project reaches stable 1.0.

---

# Security

Security issues should be handled through the project's dedicated security-disclosure process rather than public issue threads.

The security model is centered on:

- explicit authorization
- least privilege
- identity assurance
- secret isolation
- domain isolation
- input validation
- prompt-injection resistance
- idempotency
- reconciliation
- auditability
- bounded automation
- human escalation

Before 1.0, the repository should contain a complete public `SECURITY.md` with the supported disclosure channel, response expectations and security-policy scope.

---

# Governance

The project separates:

- platform architecture
- domain ownership
- security authority
- release authority
- contributor review
- operational approval

Architecture and high-impact changes should be reviewable and traceable.

A dedicated `GOVERNANCE.md` should document the maintainer model, decision process, release authority and architectural decision process before stable 1.0.

---

# Code of Conduct

Contributors are expected to participate respectfully and professionally.

A dedicated `CODE_OF_CONDUCT.md` should be included in the repository's public OSS surface before community launch.

---

# Support

Use the project's public documentation first for:

- installation
- configuration
- development
- deployment
- operations
- troubleshooting

For bugs, use the repository issue process.

For security issues, use the private security disclosure process rather than a public issue.

A dedicated `SUPPORT.md` should define the final support channels and expectations before stable 1.0.

---

# Changelog

Release history is maintained separately from this README.

The changelog should record:

- version
- release date
- new capabilities
- behavior changes
- breaking changes
- migrations
- security changes
- documentation changes
- operational implications

See `CHANGELOG.md` when available.

---

# License

The project is intended to be released under the **Apache License 2.0**.

The repository should include the complete `LICENSE` and, where required, `NOTICE` files at the repository root before a stable public release.

---

# Current external tool installation notes

The Claude Code, Codex CLI and OpenCode installation commands in this README are external tool instructions and may change independently of this repository. Before automating them in CI or an installer, verify the current upstream documentation.

- Claude Code: official Claude Code documentation
- Codex CLI: official OpenAI Codex documentation
- OpenCode: official OpenCode documentation

The project does **not** pin these developer-agent CLIs as application dependencies.

---

# Acknowledgements

n8n Agent DDD builds on and integrates with the broader open-source and developer-tool ecosystem.

The project intentionally keeps provider-specific capabilities behind adapters and contracts so the core domain architecture is not coupled to a single vendor.

Attribution and third-party license obligations should be maintained in the repository's `NOTICE` / third-party attribution process.

---

## Project philosophy

n8n Agent DDD is built around a simple idea:

> **Autonomous agents should be treated as software systems, not just prompts.**

A useful business agent needs:

```text
Reasoning
+
Domain logic
+
State
+
Authorization
+
Tools
+
Verification
+
Security
+
Observability
+
Deployment
+
Reconciliation
+
Human ownership
```

n8n provides the orchestration runtime.

The domain model provides business meaning.

PostgreSQL provides durable state.

Adapters connect the system to channels and external providers.

WF-10 protects consequential actions.

WF-20 protects commerce execution.

Harness provides the developer/AI control plane.

And the evidence framework determines what the system can legitimately claim about its runtime maturity.

---

**n8n Agent DDD — build autonomous business agents with explicit domain boundaries, deterministic orchestration, and controlled autonomy.**
