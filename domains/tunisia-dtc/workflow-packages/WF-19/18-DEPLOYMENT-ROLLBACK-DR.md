# Deployment, Rollback & Disaster Recovery

## Deployment
1. validate workflow exports;
2. validate environment variables;
3. validate credential references;
4. run health checks;
5. deploy;
6. verify critical workflows;
7. verify security boundaries;
8. monitor.

## Rollback
- restore last approved workflow/config version;
- preserve audit events;
- verify health;
- reconcile unknown executions;
- confirm security controls;
- release only after validation.

## Disaster recovery
Back up:
- n8n workflow definitions;
- configuration manifests;
- Supabase schema/backups;
- KB source/version metadata;
- audit/outbox data;
- deployment manifests.

Recovery is incomplete until:
- critical workflows are healthy;
- WF-10 boundary works;
- WF-20 boundary works;
- audit is durable;
- reconciliation backlog is controlled.
