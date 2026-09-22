---
description: Validate a domain pack against the platform contract and explain any failure.
argument-hint: [domain id, or blank for every domain]
allowed-tools: Bash(pnpm validate), Bash(pnpm test), Bash(bash tests/*), Bash(bash scripts/platform/*), Read, Glob, Grep
---

Validate: $ARGUMENTS

## Steps

1. Run, from the repository root:

   ```bash
   pnpm validate
   bash tests/platform/shared-workflow-library.sh
   bash tests/runtime/workflow-sync.sh
   bash tests/platform/domain-scaffold.sh
   ```

2. Read each failure against what actually enforces it, and report the cause
   rather than the message:

   | Failure | What it means |
   |---|---|
   | `workflow_roles is missing '<role>'` | the pack does not map a required role to one of its own ids |
   | `role '<role>' names X, which is not in the domain registry` | `domain.yaml` and `workflows/registry.yaml` disagree |
   | `role '<role>' names X, which has no workflow.yaml` | no `workflows/X/workflow.yaml` |
   | `<domain> <role> (X) invariant missing: ...` | the role's workflow contract omits an invariant `scripts/validate-runtime.ts` requires |
   | `domain pack ... is missing <entry>` | `spec/domains/domain-pack-contract.yaml` requires that file or directory |
   | `references unknown library entry` | a `from_library` value is not in `platform/workflows/library.yaml` |
   | `workflow directories missing from registry` | a directory under `workflows/` is not declared |
   | scaffold test fails | `templates/domain-pack/` has rot, or gained a placeholder the scaffold cannot fill |

3. `privileged_external_execution` is required **only** when
   `sources_of_truth.commerce` in `domain.yaml` is not `none`. A pack with
   `commerce: none` declaring four roles is correct, not incomplete — see
   `domains/demo-booking/`.

4. Fix the domain pack. Do not relax a validator, a contract under `spec/`, or
   `contracts/platform/` to make a domain pass; those are the platform's safety
   boundaries and a domain is the thing that has to fit them.

5. Report which domains passed, what failed, and what you changed.
