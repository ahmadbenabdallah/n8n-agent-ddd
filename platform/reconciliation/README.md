# Reconciliation

An unknown external execution outcome is not equivalent to failure.

If an external request may have succeeded but the response was lost:

1. persist the unknown state;
2. query the external source of truth;
3. reconcile using the idempotency key/correlation ID;
4. only then continue or retry.

Never blindly repeat a potentially successful commerce mutation.
