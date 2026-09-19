# Node-by-node configuration

1. Execute Workflow Trigger
   - Called after WF-02.
2. Validate State Input
   - Requires conversation_id, channel, channel_user_id, message_id.
3. State Input Valid?
   - Reject malformed state requests.
4. Prepare State Key
   - Builds deterministic conversation key.
5. Load Conversation State
   - Production replacement: Supabase/Redis/other trusted state store.
6. Increment Turn Count
   - Every inbound customer turn increments the counter.
7. Turn Limit Check
   - Default hard cap is 15 turns.
8. Conversation Limit Reached
   - Moves conversation to HUMAN_ESCALATION.
9. Update State From Context
   - Applies only trusted structured context.
10. Stage Transition Rules
   - Deterministic transition table.
11. Apply State Transition
   - Applies only permitted transitions.
12. Build Persistence Payload
   - Minimizes fields written to state store.
13. Persist State
   - Replace placeholder with Supabase Upsert.
14. Build State Contract
   - Contract consumed by WF-04 onward.

## Supabase

Use the `conversations` table from the production package database schema.
Use `conversation_id` as the primary key.

Recommended operation:
UPSERT conversation by conversation_id.

Do not store raw secrets, full payment data, or unnecessary private content in state.
