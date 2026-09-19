---
title: Installation
category: Installation
order: 1
---

# Installation

## Deployment profiles

The platform is provider-neutral. Supported architectural profiles include:

- local: PostgreSQL + n8n in Docker
- n8n remote: n8n hosted separately with external PostgreSQL
- VPS all-in-one: n8n + PostgreSQL
- managed provider: n8n container + managed/external PostgreSQL

Docker is the packaging boundary. Providers are adapters.

## Prerequisites

Local development:

- Git
- Bash (on Windows, Git Bash: many repository scripts are bash scripts)
- Node.js 22 exactly (`.npmrc` sets `engine-strict=true`, so installing on another major version fails)
- pnpm 10.15.0
- Docker and Docker Compose

A production environment additionally needs durable PostgreSQL, persistent n8n data, HTTPS, backup storage, deployment-managed secrets, and controlled operator access.

## Repository checks

After `pnpm install`:

```bash
pnpm run doctor     # tools and expected paths
pnpm validate   # agents, skills, platform and runtime contracts
pnpm test       # contract tests
pnpm build      # typecheck
```

## Database

Migrations are provider-neutral and live in `platform/state/db/migrations`:

```bash
DATABASE_URL=postgres://... pnpm db:migrate
```

Set `DATABASE_PROFILE=supabase` to additionally apply the Supabase-only statements in `platform/state/db/profiles/supabase/`. `pnpm db:verify` runs a migration against a throwaway Postgres in Docker and checks the security behaviour.

## Agent-installable bootstrap

The Harness bootstrap scripts exist but are still thin: `install.sh` runs the doctor, and `configure.sh` only points at the configuration contract. Treat them as entry points, not as an installer.

```bash
./scripts/harness/init.sh
./scripts/harness/doctor.sh
```

The intended interface, most of which is not implemented yet, is:

```text
harness init
harness doctor
harness install
harness configure
harness develop
harness test
harness security
harness validate
harness deploy
```

The commands are control-plane entry points; they do not bypass runtime authorization.

## Local environment

Use the repository's environment examples and runtime scripts. Keep development, staging, and production configurations separate.

Never put production credentials into local development files, Git, prompts, logs, or evidence artifacts.

## Production

Installation is not certification. Production requires the operational and evidence gates defined by the release process.
