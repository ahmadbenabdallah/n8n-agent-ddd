# Demo Booking

A second reference domain. It exists to prove the platform is domain-agnostic,
and it is deliberately as unlike `tunisia-dtc` as a useful example can be:

| | tunisia-dtc | demo-booking |
|---|---|---|
| Business | Direct-to-consumer sales | Appointment booking |
| Workflow ids | `WF-00` … `WF-20` | `BOOK-*` |
| Workflow count | 21 | 10 |
| External system of record | WooCommerce | **none** |
| `privileged_external_execution` role | WF-20 | **not required** |
| Languages | Arabic, French | English, French |

If the framework only worked for Tunisia DTC, this pack would not validate.

## What it models

A small service business taking appointments over Meta Messenger: checking
availability, holding a slot for 15 minutes, confirming, rescheduling and
cancelling, with notice periods and a cap on active bookings.

Four bounded contexts: `scheduling` (services, resources, opening hours),
`reservation` (holds and bookings), `conversation` (identity, state, intent)
and the platform-required `governance`.

## The point about `commerce: none`

`domain.yaml` declares `sources_of_truth.commerce: none`, and the pack has no
`privileged_external_execution` role. That is not an omission the validators
overlook: the platform requires that role only when a domain changes an
external system. This domain changes nothing outside its own Postgres, so a
booking is committed by the authorized branch under the same idempotency
rules, and `policies/policy-catalog.yaml` has no `commerce_execution` entry.

A booking domain that pushed confirmations into an external calendar *would*
need the role, and would fail validation without it.

## Workflows

Four of the ten are adopted from `platform/workflows/library.yaml` via
`from_library`, with this domain's own ids:

| Id | From library | Role |
|---|---|---|
| `BOOK-IN` | `messenger-inbound` | channel ingress |
| `BOOK-GUARD` | `security-gate` | security |
| `BOOK-WHO` | `identity` | identity |
| `BOOK-ROUTE` | `intent-router` | routing |
| `BOOK-AUTHZ` | — | **authorization** |
| `BOOK-REPLY` | — | **response_rendering** |
| `BOOK-AUDIT` | — | **audit** |
| `BOOK-RECON` | — | **reconciliation** |
| `BOOK-AVAIL` | — | domain: availability |
| `BOOK-RESERVE` | — | domain: reservations |

Only `BOOK-AVAIL` and `BOOK-RESERVE` are business logic. Everything else is
plumbing this domain configures rather than writes — which is the claim ADR
0002 makes, tested here for the first time.

`BOOK-IN` declares its `requires_binding` map, because the library entry calls
four other workflows and the library names no ids.

## Status

This is a **specification-level** domain pack: catalogs, policies, contracts
and invariants. It has no n8n workflow JSON of its own, and nothing imports
the adopted library entries into a running n8n — the import adapter does not
exist yet. Do not read this as a working booking agent.

What it does prove, today, is that `pnpm validate` accepts a domain whose ids,
workflow count, language set and integration shape share nothing with the
first one.
