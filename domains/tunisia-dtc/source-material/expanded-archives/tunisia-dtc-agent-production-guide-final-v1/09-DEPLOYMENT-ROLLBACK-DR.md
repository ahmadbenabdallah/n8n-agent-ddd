# Production Deployment, Rollback and Disaster Recovery

## Environments

Maintain:
- development
- staging
- production

Staging must use separate credentials and a production-like configuration.

## Release sequence

1. Freeze/approve release.
2. Validate migration plan.
3. Back up database and configuration.
4. Deploy database migrations.
5. Deploy WF-20 and test health.
6. Deploy dependent commerce services.
7. Deploy authorization/security/rendering.
8. Deploy routing/business workflows.
9. Activate channel traffic gradually.
10. Monitor.

## Canary

Prefer a controlled activation:
- internal test users first
- small production percentage where the channel architecture permits
- expand only after error, security and transaction metrics remain within thresholds

## Rollback

Rollback must preserve:
- idempotency records
- audit records
- order reconciliation
- customer context

Never “rollback” by deleting transaction evidence.

If code is rolled back but an order was already created:
- keep the order
- reconcile it
- do not create a replacement order
- preserve action ID and audit evidence

## Backups

Back up:
- Supabase database
- n8n workflows/configuration
- required encrypted credentials/secrets according to the deployment secret-management design
- KB source/version metadata
- operational configuration

Test restoration periodically.

## Recovery objectives

Define and document:
- RPO for Supabase
- RTO for n8n
- RTO for commerce integration
- maximum acceptable degraded-mode duration

The values must be selected by the operator/business; this guide does not invent business-specific targets.

## Disaster mode

If transaction integrity is uncertain:
- disable order creation
- keep support/sales informational responses running where safe
- preserve purchase intent
- alert the operator
- reconcile before re-enabling mutations
