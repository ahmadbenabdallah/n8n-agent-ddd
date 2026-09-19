# Tunisia DTC Agent — Production Guide

This package is the master implementation and deployment guide for the existing Tunisia DTC AI Sales & Support Agent.

## Start here

1. `00-MASTER-IMPLEMENTATION-GUIDE.md`
2. `01-IMPLEMENTATION-ORDER-AND-SPEC-MATRIX.md`
3. `02-N8N-INTEGRATION-RUNBOOK.md`
4. `03-DATABASE-KB-COMMERCE-INTEGRATION.md`
5. `04-TESTING-AND-RED-TEAM-RUNBOOK.md`
6. `05-PRODUCTION-DEPLOYMENT-ROLLBACK-OPERATIONS.md`
7. `06-GAPS-AND-NOT-YET-PRODUCTION-READY.md`

## Core principle

> LLM proposes → n8n validates/authorizes → commerce executes → n8n verifies → renderer responds.

## Important

The guide deliberately identifies remaining real-world integration work. The 20 workflows are not treated as magically production-integrated merely because they exist as JSON.

The merchant's actual commerce platform, payment provider, channel credentials, support destination, production traffic profile, RPO/RTO and verified merchant data must still be supplied and tested.
