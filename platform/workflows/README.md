# Shared workflow library

Reusable n8n workflows any domain can adopt instead of writing its own. The
catalogue is `library.yaml`; each entry ships the n8n JSON it refers to.

ADR 0002 splits a domain's workflows into plumbing and business logic. This is
the plumbing: the parts that do not change when the business changes. A booking
agent and a sales agent need the same security gate and the same identity
resolution; they do not need the same pricing rules.

## What is here

| Entry | Category | Domain-agnostic | Needs binding |
|---|---|---|---|
| `security-gate` | security | yes | no |
| `identity` | identity | yes | no |
| `intent-router` | routing | language set is configurable | no |
| `messenger-inbound` | ingress | yes, but specific to Meta Messenger | yes |

`security-gate` and `identity` contain no domain, channel or provider
reference at all: they call no other workflow, read no environment variable
and name no table. `messenger-inbound` is channel-specific rather than
domain-specific, which is a different thing: any domain speaking Messenger can
adopt it, and it is useless to a domain that speaks WhatsApp only.

## Adopting an entry

Reference it from your domain's `workflows/registry.yaml` with a domain-local
id of your choosing:

```yaml
- id: BOOK-GUARD          # your id, not the library's
  name: Prompt security gate
  category: security
  scope: shared
  from_library: security-gate
  protected: true
```

`scope: shared` records that the logic is not yours to diverge from;
`from_library` records where it came from so an upgrade can find it. The id
stays yours, because ids belong to the domain (ADR 0001).

An entry with `requires_binding` calls other workflows. The library names the
role or entry it needs, never an id; you supply your own ids when you import.
`messenger-inbound` needs four: security gate, identity, conversation and
intent router.

## What this library is not

It is not a runtime. Nothing here is imported into n8n automatically yet; the
import adapter is still a placeholder. Adopting an entry today means copying
the JSON into your own workflow set and rewiring the bindings by hand.

It is also not versioned independently. An entry changes when the platform
changes it, and a domain that has copied it will not pick that up
automatically.

## Provenance

These were extracted from the reference domain's workflow packages under
`domains/tunisia-dtc/workflow-packages/`, which remain that domain's own
record. The reference domain has not yet been switched over to consume them
from here, so the two copies can drift until it is.
