# WF-10 Validation Pipeline

Receive proposal
→ validate envelope
→ validate proposal schema
→ validate action count/IDs
→ allowlist lookup
→ parameter schema validation
→ deterministic normalization
→ reject arbitrary URLs/headers/credentials/code
→ load canonical WF-03 state
→ load WF-02 identity/order scope
→ load WF-08 ownership
→ evaluate action policy
→ check freshness
→ check security/risk flags
→ check idempotency/replay
→ produce decision
→ if authorized, create short-lived authorization record
→ route only to designated workflow
→ post-execution verification.

Examples:
- unknown action → DENIED
- malformed parameters → DENIED
- identity conflict → DENIED/HUMAN_REQUIRED
- expired scope → NEEDS_VERIFICATION
- human-owned conversation + normal mutation → HUMAN_REQUIRED
- stale checkout facts → NEEDS_VERIFICATION
- duplicate idempotency key → reconcile; do not blindly execute twice
