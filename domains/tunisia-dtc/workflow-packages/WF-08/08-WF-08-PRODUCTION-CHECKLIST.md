# WF-08 Production Checklist

## Case lifecycle
- [ ] Case states are allowlisted.
- [ ] Invalid transitions fail closed.
- [ ] Case creation is idempotent.
- [ ] Reopen behavior is deterministic.
- [ ] Exactly one active owner is enforced.

## Ownership
- [ ] HUMAN takeover changes conversation ownership.
- [ ] PAUSED blocks conflicting autonomous actions.
- [ ] SAFE_ONLY is explicitly defined.
- [ ] AI cannot self-assign human ownership.
- [ ] Human release is explicit.

## Security
- [ ] Customer cannot mutate case ownership.
- [ ] Untrusted events cannot trigger takeover.
- [ ] Secrets never enter case/LLM/customer context.
- [ ] Public-channel privacy is enforced.
- [ ] Stale lifecycle events are rejected.

## Integration
- [ ] WF-03 owns canonical conversation state.
- [ ] WF-10 rechecks ownership before consequential actions.
- [ ] WF-16 owns customer-facing acknowledgement.
- [ ] WF-17 receives audit events.
- [ ] WF-19 receives operational failure signals.

## Operations
- [ ] Human notification path is implemented.
- [ ] Assignment/takeover path is implemented.
- [ ] SLA timestamps are captured.
- [ ] Failed notifications do not destroy cases.
- [ ] Case-system outage has safe fallback.
- [ ] Reconciliation exists for uncertain writes.

## Production gate

Mandatory escalation, ownership, concurrency, idempotency and security tests must pass before production.
