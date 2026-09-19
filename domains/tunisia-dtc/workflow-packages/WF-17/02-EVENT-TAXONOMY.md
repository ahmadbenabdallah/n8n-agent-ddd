# WF-17 Event Taxonomy

## Gateway
- `request.received`
- `request.rejected`
- `request.normalized`

## Security
- `security.check_started`
- `security.check_passed`
- `security.check_failed`
- `security.incident_detected`

## Identity
- `identity.resolved`
- `identity.match_found`
- `identity.verification_requested`
- `identity.verification_passed`
- `identity.verification_failed`
- `identity.conflict_detected`
- `identity.scope_created`
- `identity.scope_revoked`
- `identity.scope_expired`

## Conversation
- `conversation.state_loaded`
- `conversation.state_updated`
- `conversation.owner_changed`
- `conversation.mode_changed`

## Intent / reasoning
- `intent.resolved`
- `llm.requested`
- `llm.completed`
- `llm.failed`
- `llm.output_rejected`
- `llm.proposal_created`

## Authorization
- `action.authorization_requested`
- `action.authorized`
- `action.denied`
- `action.needs_clarification`
- `action.needs_verification`
- `action.human_required`
- `action.reconciliation_required`

## Commerce
- `commerce.execution_started`
- `commerce.execution_succeeded`
- `commerce.execution_failed`
- `commerce.execution_unknown`
- `commerce.verification_succeeded`
- `commerce.verification_failed`
- `commerce.reconciliation_started`
- `commerce.reconciliation_resolved`

## Product/cart/promotion/checkout
- `product.lookup`
- `cart.read`
- `cart.mutated`
- `promotion.validated`
- `checkout.preflight`
- `checkout.order_created`

## Payment
- `payment.status_read`
- `payment.state_changed`
- `payment.dispute_detected`

## Human
- `escalation.triggered`
- `human.case_created`
- `human.assigned`
- `human.started`
- `human.resolved`
- `human.released`
- `human.case_closed`

## Rendering/delivery
- `response.rendered`
- `response.validation_failed`
- `response.fallback_used`
- `response.delivery_started`
- `response.delivered`
- `response.delivery_failed`

## Operations
- `workflow.started`
- `workflow.completed`
- `workflow.failed`
- `workflow.timeout`
- `retry.started`
- `retry.exhausted`
- `rate_limit.triggered`
