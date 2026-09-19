---
name: core:skill-discovery
description: Discover the minimum shared skills required for a task before implementation.
---

# core:skill-discovery

## Required sequence

1. Read `AGENTS.md`.
2. Read `agent-manifest.yaml`.
3. Read `.agents/skills/registry.yaml`.
4. Classify the task by lifecycle stage, layer, domain and risk.
5. Select the minimum applicable skills.
6. Load deeper references only when needed.
7. Record the selected skills in the task execution state.

## Safety

Never select a skill as permission to bypass a security, authorization or deployment policy.
