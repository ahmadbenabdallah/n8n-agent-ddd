# Tunisia DTC reference material

Two folders hold the design work behind this domain. Neither is the executable set.

| Folder | What it is |
|---|---|
| `workflow-packages/WF-00 … WF-20` | The implementation package per workflow: specification, action catalog, validation pipeline, authorization record, n8n implementation notes, security and OWASP tests, end-to-end flows, production checklist, dependency matrix and setup guides. WF-00, WF-01, WF-02 and WF-04 also include a fuller workflow JSON. |
| `source-material/` | Earlier versions of the same packages (v1 to v3), the full implementation guide (v5) and the system integration package. |

## Canonical locations

| What | Where |
|---|---|
| Executable n8n workflows | `runtime/n8n/workflows/` (all placeholders today) |
| Workflow contracts | `domains/tunisia-dtc/workflows/WF-xx/` |
| Workflow registry | `domains/tunisia-dtc/workflows/registry.yaml` |
| Prompts | `domains/tunisia-dtc/prompts/` |
| Domain contracts | `domains/tunisia-dtc/contracts/` |
| Security policy | `domains/tunisia-dtc/security/` |
| Tests and red-team suite | `domains/tunisia-dtc/tests/` |

## Notes

- The zip archives are in git history, and the pre-git release zips are on the GitHub release `archive-v0.13.0-v0.20.3`.
- Where `source-material/` held a byte-identical copy of a `workflow-packages/` package, the copy was removed; the per-workflow package is the one that is kept.
- The WF-19 and WF-20 v1 packages were missing files that existed only inside their zips (a workflow JSON each, and a WordPress plugin); those were restored.
