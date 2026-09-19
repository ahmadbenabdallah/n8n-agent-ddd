# Production Definition of Done

The system is production-ready only when all of the following are true.

## Architecture
- 21 numbered workflows (WF-00 through WF-20) are implemented or explicitly disabled with documented rationale.
- Boundaries are enforced.
- No hidden direct path from LLM to privileged commerce APIs.

## Authority
- WF-10 is the only authorization boundary.
- WF-20 is the only privileged WooCommerce gateway.
- LLM outputs remain untrusted until validation.

## Commerce
- live price/stock validation;
- live promotion validation;
- checkout revalidation;
- COD semantics;
- idempotent mutation;
- post-action verification;
- unknown execution reconciliation.

## Identity
- identity ladder implemented;
- order scope implemented;
- website-originated order linking supported;
- unauthorized order access blocked.

## Human ownership
- mandatory escalation rules implemented;
- human case states implemented;
- actual notification/assignment state tracked;
- automation stops conflicting actions.

## Security
- OWASP-oriented controls tested;
- secrets isolated;
- public-channel privacy enforced;
- prompt injection and KB poisoning tested.

## Observability
- audit events durable;
- security events visible;
- operational metrics available;
- alerts configured.

## Recovery
- backup;
- restore;
- rollback;
- reconciliation;
- incident procedures tested.

## Final invariant

> **LLM proposes → n8n validates → WF-10 authorizes → WF-20 executes → WooCommerce verifies → WF-16 renders → WF-17 audits → WF-19 monitors.**
