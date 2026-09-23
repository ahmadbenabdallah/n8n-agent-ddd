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
- LLM output cannot directly authorize privileged external execution.
- Only the workflow filling the `authorization` role may authorize execution.
- Only the workflow filling the `privileged_external_execution` role may mutate
  an external system of record.
- Workflow ids belong to the domain. Each domain maps the platform roles to its
  own ids in `domains/<name>/domain.yaml` under `workflow_roles`; the reference
  domain `tunisia-dtc` happens to use WF-10 and WF-20. Never hardcode a
  workflow id in platform code, specs or contracts.
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

<!-- OPENWIKI:START -->

## OpenWiki

This repository has a generated `openwiki/` evidence index. It is optional just-in-time context, not required startup reading.

- Treat source code and tests as authoritative. A brief's unknowns and review items are verification gaps, not automatic requirements.
- Prefer the narrowest quiet validation that proves the changed behavior. Preserve complete failure output.

The scheduled OpenWiki GitHub Actions workflow refreshes the repository wiki. Do not hand-edit generated OpenWiki pages unless explicitly asked; prefer updating source code/docs and letting OpenWiki regenerate.

<!-- OPENWIKI:END -->
