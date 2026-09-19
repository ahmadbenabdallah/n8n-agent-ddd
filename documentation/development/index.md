---
title: Developer Guide
category: Development
order: 1
---

# Developer Guide

## Engineering source of truth

Git is the source of truth for code, contracts, domain packs, workflows, policies, skills, tests, and documentation.

## Before changing a feature

1. Identify the domain.
2. Identify affected workflows and contracts.
3. Identify security and authorization impact.
4. Identify migration/state impact.
5. Define acceptance criteria.
6. Define tests and required evidence.
7. Use an isolated branch/worktree.

## Definition of Ready

A task is ready when its scope, affected contracts, acceptance criteria, security impact, dependencies, and migration/rollback requirements are understood.

## Definition of Done

A task is complete only when implementation, tests, security review, architecture review, documentation, and required evidence are complete.

## Internal vs public docs

Public developer guidance lives in `documentation/development/`.

Detailed internal architecture, certification procedures, operational evidence runbooks, and internal security test material live under `docs/` and are not published to ReadMe.

## Core boundaries

Never:

- move authorization into an LLM prompt
- allow the LLM to directly execute commerce mutations
- bypass WF-10
- put privileged credentials in LLM/customer context
- treat n8n execution data as the only business source of truth
- SSH directly into production from a coding agent
- claim live evidence without executing the corresponding test
