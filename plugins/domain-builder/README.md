# domain-builder

A Claude Code plugin for adopters of the
[n8n-agent-ddd](https://github.com/ahmadbenabdallah/n8n-agent-ddd) framework.
It builds **domain packs**: the specification of one business agent that the
framework then runs.

It is not the framework's own development setup. Nothing in it is specific to
how this repository is maintained.

## Install

```
/plugin marketplace add ahmadbenabdallah/n8n-agent-ddd
/plugin install domain-builder@n8n-agent-ddd
```

The marketplace manifest lives at `.claude-plugin/marketplace.json` in the
repository root and sources this plugin from the `plugins/domain-builder`
subdirectory, so there is no second repository to track.

The commands operate on a checkout of the framework: `cd` into one first, or
they have no `templates/domain-pack/` to read.

## Commands

| Command | Does |
|---|---|
| `/scaffold-domain` | instantiates `templates/domain-pack/` into a new, valid `domains/<id>/` pack |
| `/adopt-workflow` | references an entry from `platform/workflows/library.yaml` under the domain's own id |
| `/validate-domain` | runs the platform validators and explains the failures |

## Skill

`domain-pack` loads whenever you touch `domains/`, `templates/domain-pack/` or
`platform/workflows/`. It carries the one rule that is easiest to break: the
platform defines *roles*, and each domain maps those roles onto *its own*
workflow ids. No platform artifact may name an id.

## The scaffold is a script, not a prompt

`scripts/scaffold-domain.mjs` does the work — plain Node, no dependencies, so
it runs in a checkout that has not been installed yet:

```bash
node plugins/domain-builder/scripts/scaffold-domain.mjs \
  --id demo-clinic --name "Demo Clinic" --prefix CLIN \
  --context scheduling --responsibility "Appointments, clinicians and slots." \
  --commerce none
```

It fills every platform-contract placeholder — identity, adapters, versions,
policies, and the role-to-id mapping — and produces a pack that passes
`pnpm validate` unedited. What it deliberately leaves is the domain model:
entities, aggregates, value objects, commands, events, projections, business
rules and invariant cases. It lists those in the new pack's `README.md`; the
command then fills them with you.

Any placeholder that is neither substituted nor on that list is a **hard
error**. That is the point: `tests/platform/domain-scaffold.sh` instantiates
the template on every test run, so a placeholder added to the template, or a
reference-domain workflow id leaking into it, fails there rather than in an
adopter's first copy. The template last rotted for a whole refactor precisely
because nothing ever instantiated it — see
`runtime/evidence/validation/F1.md`.

`--commerce` is the consequential option. `none` means the domain changes
nothing outside its own Postgres, so the platform does not require the
`privileged_external_execution` role and the scaffold omits it. Naming a system
adds that role and a `commerce_execution` policy.

## For Codex, Cursor, Copilot and the rest

Nothing here is needed. `AGENTS.md` at the repository root is the cross-tool
contract, and `.agents/skills/` is the shared skill library.

Apache-2.0, same as the framework.
