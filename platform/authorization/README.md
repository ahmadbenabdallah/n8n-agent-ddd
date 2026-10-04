# Authorization

Authorization is a hard boundary, and since NAD-015 it is one in code.

[`port.ts`](port.ts) holds both halves:

```text
LLM proposes an action          (ActionProposal: no execution_allowed member)
  ↓
authorizeAction()               deny-by-default, writes a record to public.authorizations
  ↓
requireAuthorizedExecution()    loads that record by authorization_id, or throws
  ↓
the workflow filling the privileged_external_execution role executes
```

`execution_allowed` is produced by the decision and read back from the
database. It is not a payload field: a request that carries one is stripped and
denied. The executor is given an `authorization_id` and nothing else that
resembles authority, and it verifies the stored record is `AUTHORIZED`,
unexpired, and bound to this action and idempotency key.

The decision lives here rather than in the n8n graph because every workflow in
`runtime/n8n/workflows/` is a placeholder and the local n8n allowlists no
builtins. The graphs are now only consistent with this module: WF-10 refuses
caller-supplied authority instead of computing it, and WF-20's gate requires an
`authorization_id`. Neither decides anything.

Roles, never workflow ids: the executing workflow is resolved through
`readWorkflowRoles` from the domain's own `workflow_roles` block (ADR 0001), so
a domain that declares no `privileged_external_execution` role has no workflow
that may execute. Be precise about what that check is worth: `workflow_id` is a
string the caller supplies about itself, so matching it against the domain's
nomination catches a workflow that was never nominated and a domain that
nominated none - configuration consistency, not caller identity. Likewise the
record's `authorized_by_role` is written by the port about itself. Which
component may call either function is a runtime credential-scoping question and
is not answerable here.

The domain's vocabulary stays the domain's: the levels that clear the identity
gate arrive in the context, read from the domain's `identity_ladder`
(`tunisia-dtc` spells one `CHANNEL-LINKED`, `demo-booking` spells its own
`CHANNEL_VERIFIED`). The only level platform *code* names is `ANONYMOUS`, and
it names it because it is the platform's own default:
`customer_identities.assurance_level` is `text DEFAULT 'ANONYMOUS' NOT NULL`,
so that is what an identity row reads when nothing was ever established. The
port refuses it even if a domain lists it as sufficient. One word is defensible
where a list would not be: the leak class is platform code asserting a grant
vocabulary, and this is a deny on the default, where a spelling mismatch could
only fail to override a level the domain itself allowed.

In scope today: deny-by-default with the identity gate and the action
allowlist. The other gates of
[`01-WF-10-AUTHORIZATION-SPEC.md`](../../domains/tunisia-dtc/workflow-packages/WF-10/01-WF-10-AUTHORIZATION-SPEC.md)
(ownership, freshness, business policy, parameter constraints) are domain policy
and follow.

Behaviour is pinned by [`tests/unit/authorization/boundary.ts`](../../tests/unit/authorization/boundary.ts).
