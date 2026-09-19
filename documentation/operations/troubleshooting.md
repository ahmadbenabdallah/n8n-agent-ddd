---
title: Troubleshooting
category: Operations
order: 2
---

# Troubleshooting

## n8n unavailable

Check runtime health and the n8n service. Do not recreate durable application state merely because orchestration is temporarily unavailable.

## PostgreSQL unavailable

Restore database connectivity before executing state-changing operations. PostgreSQL is the durable state layer.

## Commerce timeout

Do not blindly retry a mutation. Reconcile the provider state first because the mutation may already have committed.

## Workflow inventory mismatch

Compare the runtime inventory with the canonical WF-00 through WF-20 set. Protected workflows must be changed through the release process.

## Missing secret

Check deployment-layer secret injection. Never paste a secret into logs, Git, an issue, an LLM prompt, or a customer message.

## Cross-domain access problem

Check the complete scope:

- domain_id
- n8n project
- workflow namespace
- database scope
- knowledge namespace
- authorization scope
- audit scope

Cross-domain access is denied by default.

## Certification not ready

`NOT_READY` means required evidence is missing or a gate is not satisfied. It is not a signal to bypass the gate.
