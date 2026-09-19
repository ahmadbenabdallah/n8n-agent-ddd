# Node-by-node configuration

### 1. Execute Workflow Trigger
Called by WF-04.

### 2. Validate Sales Input
Requires:
`message_id`, `conversation_id`, `text`, `intent`, `identity`, `state`.

### 3. Sales Input Valid?
Fail-closed branch if required data is missing.

### 4. Fail Closed
Creates an escalation-safe object. No commerce tools.

### 5. Load Sales Context
Normalizes the stage and defines the allowed sales-intent set.

### 6. Sales Intent?
Routes only sales intents into this engine.

### 7. Route Non-Sales
Returns control to the appropriate non-sales workflow.

### 8. Extract Sales Signals
Extracts only simple non-authoritative signals such as a size or quantity. These values are proposals, not authorization.

### 9. Sales State Machine
Maps intent to the next permitted sales stage and proposed action.

### 10. Clarification Needed?
Prevents ambiguous cart operations from progressing.

### 11. Build Sales Clarification
No commerce tools when required context is missing.

### 12. Build Sales Plan
Sets retrieval/tool requirements and whether an action proposal may be generated.

### 13. Build Sales Contract
Final contract consumed downstream.

## Production note

Do not replace deterministic business transitions with free-form LLM output. The LLM can explain, compare, discover and propose; the state machine remains controlled by orchestration.
