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
- Bash
- Node.js
- pnpm
- Docker
- Docker Compose

A production environment additionally needs durable PostgreSQL, persistent n8n data, HTTPS, backup storage, deployment-managed secrets, and controlled operator access.

## Agent-installable bootstrap

The Harness installation flow is designed for developers and coding agents:

```bash
./scripts/harness/install.sh
./scripts/harness/init.sh
./scripts/harness/doctor.sh
./scripts/harness/configure.sh
```

The intended Phase 18 interface is:

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
