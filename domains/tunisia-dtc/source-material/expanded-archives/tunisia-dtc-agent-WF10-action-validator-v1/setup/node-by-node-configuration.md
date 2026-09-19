# Node-by-node configuration

1 Trigger — receives LLM proposal + trusted contracts.
2 Validate input.
3 Input gate.
4 Fail closed.
5 Action allowlist.
6 Allowlist gate.
7 Unknown action denial.
8 Identity permission gate.
9 Identity gate.
10 Insufficient identity denial.
11 Parameter validation.
12 Parameter gate.
13 Invalid parameter denial.
14 Business rule gate.
15 Business-rule gate.
16 Business-rule denial.
17 Idempotency check.
18 Duplicate gate.
19 Duplicate denial.
20 Risk + security gate.
21 Risk gate.
22 Risk denial.
23 Authorized Action Contract.

## Important

The action validator is the only workflow allowed to set `execution_allowed=true`.

The downstream service must still verify the authorization contract and return an execution result.
