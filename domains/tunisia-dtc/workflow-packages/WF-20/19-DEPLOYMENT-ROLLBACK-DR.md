# Deployment, Rollback & DR

## Deployment
1. validate operation registry;
2. validate credentials;
3. run read-only health checks;
4. test product/order reads;
5. test controlled mutation in staging;
6. verify authorization binding;
7. deploy;
8. monitor.

## Rollback
- restore previous gateway version;
- preserve idempotency records;
- preserve audit events;
- verify authorization boundary;
- reconcile unknown commerce operations;
- confirm credentials.

## DR

Back up:
- operation registry;
- gateway configuration;
- normalization schemas;
- idempotency records;
- deployment manifests.

Do not back up secrets into application data stores.
Use approved secret-manager/credential backups separately.
