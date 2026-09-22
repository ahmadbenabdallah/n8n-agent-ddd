---
description: Scaffold a new domain pack from templates/domain-pack and fill the platform contract.
argument-hint: [domain description, e.g. "a clinic booking appointments over Messenger"]
allowed-tools: Bash(node:*), Bash(pnpm validate), Bash(git rev-parse:*), Read, Edit, Glob, Grep
---

Scaffold a new domain pack in this n8n-agent-ddd checkout for: $ARGUMENTS

## What the scaffold decides, and what you must not

`scripts/scaffold-domain.mjs` instantiates `templates/domain-pack/` and fills
every platform-contract placeholder. **You do not hand-write any of it.** If a
placeholder that the scaffold should have filled survives, that is a bug in the
scaffold or rot in the template — report it, do not paper over it by editing the
generated file.

The one rule you must not break: **the platform names no workflow id.** Roles
(`authorization`, `response_rendering`, `audit`, `reconciliation`, and
`privileged_external_execution` only when the domain changes an external system)
are mapped to *this domain's own* ids in `domain.yaml` under `workflow_roles`.
Never copy an id out of `domains/tunisia-dtc/`; it is one example's ids, nothing more.

## Steps

1. Read `templates/domain-pack/README.md` and `domains/demo-booking/README.md`.
   `demo-booking` is the better model: four roles, `commerce: none`, its own ids.

2. Settle these with the user before running anything. Ask only for what you
   cannot infer from `$ARGUMENTS`; propose defaults and let them correct you.

   | Option | Meaning |
   |---|---|
   | `--id` | stable lowercase kebab-case domain id |
   | `--name` | human-readable name |
   | `--prefix` | the prefix for this domain's own workflow ids, e.g. `CLIN` |
   | `--purpose` | one sentence: who the agent serves, on what channel, doing what |
   | `--context` | id of the primary bounded context (`governance` is added for you) |
   | `--responsibility` | what that context owns |
   | `--channel` | channel adapter, default `meta-messenger` |
   | `--commerce` | external system of record, or `none` |
   | `--language` | default language code |

   `--commerce` is the consequential one. `none` means the domain changes
   nothing outside its own Postgres, so the platform does not require the
   `privileged_external_execution` role and the scaffold omits it. Naming a
   system means the domain gets that role and a `commerce_execution` policy.
   Ask; do not guess.

3. Run it:

   ```bash
   node "${CLAUDE_PLUGIN_ROOT}/scripts/scaffold-domain.mjs" \
     --id <id> --name "<Name>" --prefix <PREFIX> \
     --purpose "<one sentence>" --context <context-id> \
     --responsibility "<what it owns>" --commerce <system|none>
   ```

   It prints the role-to-id mapping and the placeholders left for the author.

4. Run `pnpm validate`. It must pass with no edits to the generated files. If it
   does not, the scaffold is wrong — say so rather than patching the output.

5. Fill the domain model, and only the domain model: the entities, aggregates,
   value objects, commands, events, projections, business rules and invariant
   test cases listed under "Still to write" in the new pack's `README.md`.
   Use `.agents/skills/domain/` for how to model those. Derive them from what
   the user told you; invent no business rule they did not state.

6. Show the user the role table and the remaining placeholders. Do not add n8n
   workflow JSON: a scaffolded pack is specification-level, like `demo-booking`.
