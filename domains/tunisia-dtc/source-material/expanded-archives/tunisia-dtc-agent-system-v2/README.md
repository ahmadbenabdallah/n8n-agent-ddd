# Tunisia DTC Agent — System Package v2

This package contains the updated control-layer files for the Tunisia DTC
sales/support agent.

## Included

- 01-system-prompt.md — authoritative behavior and hard script-preservation policy
- 02-orchestrator-prompt.md — trusted language/script metadata and execution context
- 04-sales-business-logic.md — sales/cart intent refinements
- 06-security-policy.md — output/script validation security control
- 10-output-schema-v2.json — adds language, script and register to structured output
- tests/language-script-regression.md — Playground regression tests

## Important architecture

System Prompt = authoritative policy.
Orchestrator = trusted runtime context and metadata.
LLM = proposes response/actions.
Application = validates/authorizes.
Commerce system = executes.
Response renderer/validator = final channel + script enforcement.

The system package must NOT be inserted into the vector KB. These files are
control/configuration, not customer-facing factual knowledge.
