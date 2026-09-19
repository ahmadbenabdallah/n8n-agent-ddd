# WF-05 Production Checklist

## Architecture
- [ ] WF-05 has no direct WooCommerce credentials.
- [ ] WF-05 does not bypass WF-10.
- [ ] WF-20 remains the only privileged WooCommerce boundary.
- [ ] WF-05 delegates product/cart/promotion/checkout/order operations correctly.
- [ ] WF-03 is canonical state owner.

## Sales state
- [ ] Primary sales state machine is implemented.
- [ ] Supporting states are implemented.
- [ ] All transitions are allowlisted.
- [ ] Invalid transitions fail closed.
- [ ] State writes use optimistic/idempotent persistence.

## Intent
- [ ] Specific intents have precedence.
- [ ] Cart intents cannot regress into generic discovery.
- [ ] Checkout confirmation requires explicit confirmation where required.
- [ ] Human-owned messages respect case ownership.

## Commerce facts
- [ ] Current price comes from authoritative source.
- [ ] Current availability comes from authoritative source.
- [ ] Promotions are validated by WF-13.
- [ ] Checkout freshness is enforced by WF-14.
- [ ] No manual checkout URL construction.

## Security
- [ ] LLM output is treated as untrusted.
- [ ] No identity promotion in WF-05.
- [ ] No private order context outside verified scope.
- [ ] No secrets in prompts/logs.
- [ ] Prompt injection tests pass.
- [ ] Fabricated scarcity/social-proof tests pass.
- [ ] Duplicate-action tests pass.

## Human handoff
- [ ] `conversation_owner` is respected.
- [ ] `automation_mode` is respected.
- [ ] Related messages route to active case.
- [ ] Conflicting consequential actions are blocked.

## Language
- [ ] Language and script are separate.
- [ ] Latin/Arabizi script constraint is enforced.
- [ ] Renderer performs final validation.

## Operations
- [ ] Correlation IDs exist.
- [ ] Action IDs exist where actions are proposed.
- [ ] Analytics events are emitted without unnecessary PII.
- [ ] Downstream failures use bounded retries.
- [ ] Reconciliation path exists for uncertain downstream execution.

## Final gate
WF-05 is production-ready only when every critical security and business invariant passes.
