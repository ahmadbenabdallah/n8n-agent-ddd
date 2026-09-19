# Action boundary

WF-09 may return:
`{"action_proposal":{"action":"cart_add","parameters":{}},"execution_allowed":false}`

It must never return a successful execution result. WF-10 decides allowlist, identity, business rules, parameter validity, idempotency and execution.
