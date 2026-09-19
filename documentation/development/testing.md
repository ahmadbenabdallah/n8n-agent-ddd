---
title: Testing and Evidence
category: Development
order: 5
---

# Testing and Evidence

Use the smallest test that proves an invariant, then run broader gates when the change requires them.

## Test layers

- unit
- integration
- architecture
- security
- red-team
- end-to-end
- disaster recovery

## Security coverage

High-impact changes should consider:

- prompt injection
- retrieved-content injection
- forged authorization
- scope escalation
- cross-customer access
- cross-domain access
- protected workflow mutation
- secret exfiltration
- sensitive log injection
- arbitrary endpoint use
- price/stock/payment manipulation
- replay
- human ownership conflicts

## Evidence levels

A repository contract test proves that a contract is represented correctly.

It does not prove:

- a live n8n instance worked
- a real database worked
- a real channel worked
- a real commerce provider worked
- a backup restored successfully
- blue/green rollback succeeded
- production was certified

Live claims require captured runtime evidence.
