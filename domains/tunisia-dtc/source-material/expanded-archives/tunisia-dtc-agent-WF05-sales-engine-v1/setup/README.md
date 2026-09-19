# WF-05 — Sales Engine

WF-05 is the deterministic sales-business-logic layer. It does **not** execute commerce actions and does not let the LLM authorize actions.

## Position

WF-03 Conversation State → WF-04 Intent Router → **WF-05 Sales Engine** → WF-09 LLM Reasoning / WF-11 Product Service / WF-12 Cart Service / WF-13 Promotion Service / WF-14 Checkout Service → WF-10 Action Validator.

Core rule:

**LLM proposes → WF-10 validates/authorizes → commerce service executes → post-action verification → response renderer.**

## What this workflow does

1. Validates the upstream contract.
2. Determines whether the message is a sales intent.
3. Loads the current sales stage from trusted state.
4. Extracts limited deterministic signals.
5. Applies the sales state machine.
6. Determines whether clarification is required.
7. Determines whether retrieval/tool access is needed.
8. Produces a bounded Sales Contract.

It intentionally does **not**:
- invent product facts;
- decide authorization;
- execute cart/checkout operations;
- claim a purchase happened;
- generate the final customer message;
- trust LLM confidence as permission.
