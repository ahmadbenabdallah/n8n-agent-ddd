# Backup Infrastructure

This directory defines the infrastructure contract for runtime persistence.

## What must be durable

1. PostgreSQL — authoritative application/domain state and n8n database state.
2. n8n persistent data — runtime-local data required by the selected deployment profile.
3. Secret material — supplied by the deployment secret manager/environment; never committed to Git.

## Recommended production shape

```text
                    ┌────────────────────┐
                    │   PostgreSQL backup │
                    └─────────┬──────────┘
                              │
                              ▼
                    ┌────────────────────┐
                    │ Object storage / DR │
                    └────────────────────┘

n8n runtime ───────► provider snapshot / persistent volume
       │
       └────────────► release + backup manifest
```

The exact object-storage/provider implementation is intentionally adapter-specific.

## Safety

- Do not put database passwords, API keys, n8n encryption keys, or provider credentials in backup manifests.
- A backup is not considered verified merely because a command returned exit code 0.
- Production restore must happen into an isolated environment before traffic is restored.
- Unknown external commerce outcomes must be reconciled rather than blindly replayed.
