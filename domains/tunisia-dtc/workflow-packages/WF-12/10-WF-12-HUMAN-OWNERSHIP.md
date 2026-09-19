# WF-12 Human Ownership

WF-08 is authoritative for conversation ownership.

Before mutation, WF-12 must ensure automation mode still permits the authorized action.

If:
`conversation_owner=HUMAN`
or
`automation_mode=PAUSED`

normal cart mutation is rejected.

If ownership changes after authorization but before execution, the authorization is invalid and the mutation must not proceed.

SAFE_ONLY behavior is determined by WF-10 policy, not WF-12 discretion.
