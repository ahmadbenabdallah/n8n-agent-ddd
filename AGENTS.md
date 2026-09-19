# Canonical Agent Contract

## Mission
Build and maintain `n8n-agent-ddd` as a production-grade domain-driven autonomous agent runtime with n8n as the primary execution runtime.

## Source of truth
1. `AGENTS.md`
2. applicable nested `AGENTS.md`
3. `agent-manifest.yaml`
4. `.agents/policies/`
5. domain specs
6. `contracts/`
7. implementation

Never invent business rules absent from the domain specification.

## Lifecycle
DISCOVER → DEFINE → DOMAIN → SPECIFY → ARCHITECT → DESIGN → DECOMPOSE → PLAN → IMPLEMENT → TEST → SECURITY → REVIEW → INTEGRATE → DEPLOY → VERIFY → OPERATE → LEARN

## Definition of Ready
Requirements, acceptance criteria, bounded context, contracts, security impact, test strategy, migration impact and rollback requirements are explicit.

## Definition of Done
Implementation, tests, contracts, architecture invariants, security checks, documentation and migration/rollback requirements are satisfied.

## Non-negotiable runtime boundaries
- LLM output cannot directly authorize commerce mutations.
- Only WF-10 may authorize commerce execution.
- Only WF-20 may execute privileged WooCommerce mutations.
- Renderer reports verified facts only.
- Audit is not authorization.
- Domain state must not depend on n8n execution history.
- Runtime secrets never enter source control or LLM/customer-visible context.
- Unknown external execution reconciles before retry.
- Order creation is not payment.
- Human ownership blocks conflicting automation.

## Production access
Agents must not SSH directly into production or bypass CI/CD. Preferred path: branch/worktree → tests → PR → GitHub Actions → deployment gates → runtime.

## n8n change procedure
Read workflow spec, contracts, business/security policies and dependencies; make the smallest safe change; validate workflow structure; run affected tests; run architecture/security validation; report risks.

## External skills/code
Before importing: identify upstream, inspect license, record version/commit, verify compatibility, preserve attribution, update `THIRD-PARTY.md`, validate.

## Uncertainty
Do not guess across security, authorization, identity, payment, migration or deployment boundaries.
