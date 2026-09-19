---
name: core:skill-validation
description: Validate skill structure, metadata, references, provenance and safety requirements.
---

# core:skill-validation

## Required sequence

1. Enumerate `.agents/skills/**/SKILL.md`.
2. Validate frontmatter.
3. Validate required sections.
4. Detect duplicate skill names.
5. Check referenced files exist.
6. Check upstream metadata when an external skill is adapted.
7. Report actionable failures.

## Safety

A skill that fails validation must not be treated as production-ready.
