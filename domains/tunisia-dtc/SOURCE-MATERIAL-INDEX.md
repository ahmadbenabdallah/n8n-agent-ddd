# Tunisia DTC Source Material Index

This directory contains the actual Tunisia DTC artifacts produced during the project, including the complete workflow package set, prompts/contracts, full implementation guide, system integration package, and all available source archives.

## Canonical workflow packages

WF-00 through WF-20 are present under `workflow-packages/`. Where a v4 package exists, it is used as the canonical package; otherwise the available v1 package is used. Older v1/v2/v3/v4 packages are preserved under `source-material/project-archives/` and expanded under `source-material/expanded-archives/`.

## Prompt and contract sources

See `prompts/` for the system prompt, orchestrator prompt, KB specification, sales logic, tool contracts, security policy, red-team suite, and output schema.

## Full implementation

`source-material/FULL-IMPLEMENTATION-GUIDE-v5/` contains the complete v5 implementation guide.

## System integration

`system-integration/` contains the final v4 integration package.

## Runtime workflow JSONs

The executable/reference n8n workflow JSON set remains under `runtime/n8n/workflows/` with WF-00..WF-20.
