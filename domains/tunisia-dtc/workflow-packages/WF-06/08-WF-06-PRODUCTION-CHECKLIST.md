# WF-06 Production Checklist

## Routing
- [ ] Support intents are allowlisted.
- [ ] Order-specific support routes through WF-07.
- [ ] Payment disputes route to WF-08.
- [ ] Human requests route to WF-08.
- [ ] Safety/security paths are enforced.

## Identity
- [ ] WF-02/WF-03 identity context is trusted.
- [ ] Order scope is enforced.
- [ ] Expired/revoked scope is blocked.
- [ ] Ambiguous candidate matches fail closed.

## Grounding
- [ ] Current operational facts come from live authoritative sources.
- [ ] Current policy has explicit authority.
- [ ] No unsupported promises.
- [ ] No fabricated delivery/refund/payment claims.

## Human handoff
- [ ] Human ownership is respected.
- [ ] Conflicting automation is blocked.
- [ ] Case creation is idempotent.
- [ ] Safe waiting/acknowledgement exists.

## Security
- [ ] Prompt-injection tests pass.
- [ ] KB-poisoning tests pass.
- [ ] Public PII tests pass.
- [ ] Payment-secret tests pass.
- [ ] Identity/scope tests pass.
- [ ] Security-suspicion tests pass.

## Language
- [ ] Language and script remain separate.
- [ ] Latin/Arabizi constraints are enforced by renderer.
- [ ] Customer register is preserved.

## Operations
- [ ] Correlation ID available.
- [ ] Action IDs used for consequential actions.
- [ ] Support events are auditable.
- [ ] Live dependency failures have bounded recovery.
- [ ] No raw secrets in logs.

## Final gate
All mandatory support, privacy, escalation and security tests must pass before production.
