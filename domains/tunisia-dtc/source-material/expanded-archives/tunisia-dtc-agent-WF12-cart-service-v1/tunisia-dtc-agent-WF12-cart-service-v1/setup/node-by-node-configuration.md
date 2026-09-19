# Node-by-node configuration

1. **Execute Workflow Trigger**
   - Called by the orchestrator/WF-10.
   - Do not expose this as a public webhook.

2. **Validate Cart Service Input**
   - Checks required contract objects and supported cart actions.

3. **Cart Input Valid?**
   - Fail closed on malformed input.

4. **Reject Invalid Cart Input**
   - Safe machine-readable failure.

5. **Recheck Authorized Action Contract**
   - Requires `execution_allowed=true`.
   - Requires identity level `channel_linked`, `order_verified`, or `high_assurance`.
   - Rechecks action allowlist.

6. **Authorization Valid?**
   - No authorization bypass.

7. **Reject Unauthorized Cart Action**
   - No commerce call.

8. **Validate Cart Parameters**
   - Quantity must be integer 1–99 for add/update.
   - SKU required for add.
   - Builds deterministic idempotency key.

9. **Parameters Valid?**
   - Fail closed.

10. **Reject Invalid Cart Parameters**
   - No commerce call.

11. **Business Rules + Stock Check**
   - Reject duplicate idempotency key.
   - Validate variant presence for add/update.
   - Require cart context for operations that need an existing cart.
   - Check known live stock.

12. **Business Rules Valid?**
   - Fail closed.

13. **Build Commerce Cart Request**
   - This is the adapter boundary.
   - In production connect the output to the real commerce API.

14. **Post-Action Verification**
   - Requires adapter result.
   - Requires `verified=true` and `owner_match=true`.
   - No success claim otherwise.

15. **Build Cart Service Contract**
   - Emits only sanitized fields.

### Connecting the adapter

The JSON deliberately leaves the adapter as an explicit boundary. In n8n, insert an HTTP Request node (or your commerce connector) between `Build Commerce Cart Request` and `Post-Action Verification`.

The adapter should receive only the normalized request, not raw customer messages or the full conversation.
