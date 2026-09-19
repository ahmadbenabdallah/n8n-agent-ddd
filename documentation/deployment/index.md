---
title: Deployment
category: Deployment
order: 1
---

# Deployment

The deployment boundary is:

```text
Git
 ↓
CI gates
 ↓
deployment contract
 ↓
runtime
 ↓
verification
```

Coding agents do not SSH directly into production.

## Release lifecycle

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

## Blue/green

1. Prepare green.
2. Verify green health.
3. Run smoke tests.
4. Explicitly switch traffic.
5. Drain blue.
6. Verify the new runtime.
7. Keep rollback available until verification is complete.

## Database migrations

Prefer:

`EXPAND → MIGRATE → VERIFY → SWITCH → CONTRACT`

Destructive changes require explicit review and a rollback strategy.

## Production gate

Production deployment requires the relevant staging evidence, certification, operational preflight, and explicit approval.

A release file or shell contract is not proof that a real deployment succeeded.

## Provider neutrality

The same runtime contract can be mapped to local Docker, a VPS, or a managed provider through deployment adapters.
