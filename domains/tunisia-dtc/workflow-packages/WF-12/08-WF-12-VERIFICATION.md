# WF-12 Post-Mutation Verification

Successful HTTP execution is not enough.

After mutation:
1. obtain authoritative cart state;
2. verify expected line/quantity/product/variation;
3. compare result to authorized parameters;
4. mark execution `SUCCEEDED` only when verified;
5. otherwise mark `UNKNOWN` or `RECONCILIATION_REQUIRED`.

Customer-facing success must only be generated from verified state.

Examples:
- requested qty 1, verified qty 1 → success.
- request timed out → unknown until reconciled.
- response says success but cart unchanged → failure/reconciliation.
