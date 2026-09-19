---
title: AI Coding Agents
category: Development
order: 7
---

# AI Coding Agents

Claude Code and Codex are development clients for the Harness control plane.

## Agent topology

```text
Chief
├── PM
├── Architect / CTO
├── Security
├── Developers
├── QA
└── Reviewer
```

## Expected lifecycle

```text
DISCOVER
→ DEFINE
→ DOMAIN
→ SPECIFY
→ ARCHITECT
→ DECOMPOSE
→ PLAN
→ IMPLEMENT
→ TEST
→ SECURITY
→ REVIEW
→ INTEGRATE
→ DEPLOY
→ VERIFY
→ OPERATE
→ LEARN
```

## Agent task state

Meaningful work is represented as a task with:

- task ID
- owner
- dependencies
- acceptance criteria
- lifecycle state
- artifacts
- evidence references

Unsatisfied dependencies block downstream work.

## Isolation

Developer agents use isolated Git worktrees. Integration goes through review and CI.

## Bounded autonomy

Agents may autonomously inspect, plan, implement scoped changes, run tests, and prepare releases.

High-impact actions remain review-gated, including production deployment, destructive migrations, credential operations, and sensitive runtime changes.

## Self-improvement

The evaluation loop is:

`OBSERVE → MEASURE → COMPARE → IDENTIFY GAP → PROPOSE CHANGE → REVIEW → TEST → ADOPT OR REJECT`

Self-improvement cannot silently change authorization policy.

## Never

- SSH directly into production
- bypass CI
- bypass WF-10
- access production secrets by default
- silently weaken security controls
- claim execution without evidence
