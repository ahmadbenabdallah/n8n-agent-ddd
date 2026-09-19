# WF-03 E2E Examples

## Example A — Order status
1. Messenger inbound.
2. WF-02 resolves customer and active order scope.
3. WF-03 sets `acknowledgement_state=CHECKING_ORDER`.
4. WF-10 authorizes `get_order`.
5. WF-20 fetches current WooCommerce order.
6. WF-03 records verified action result.
7. WF-16 renders the response.
8. Acknowledgement state clears.

## Example B — Human escalation
1. Complaint triggers WF-08.
2. WF-03 creates `case_id`.
3. `conversation_owner=HUMAN_REQUESTED`.
4. `automation_mode=SAFE_ONLY`.
5. Human accepts.
6. `conversation_owner=HUMAN`, `human_owner_id=agent_123`.
7. Conflicting AI mutation is denied.
8. Human resolves and explicitly releases case.
9. WF-03 returns to `AI/FULL` only through the release control path.

## Example C — WooCommerce timeout
1. Action authorized.
2. WF-20 request times out.
3. WF-03 records `execution_status=UNKNOWN`.
4. `reconciliation_status=RECOVERY_REQUIRED`.
5. System must reconcile before retrying a mutation.
6. LLM cannot tell customer that the operation succeeded.
