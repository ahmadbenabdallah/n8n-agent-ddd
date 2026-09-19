# Self-Hosted n8n Deployment Guide

## Required controls

- persistent database;
- encrypted credentials;
- stable encryption key;
- HTTPS;
- restricted admin access;
- separate staging/production;
- backup;
- error workflow;
- execution retention;
- health checks;
- monitoring.

## Workflow conventions

Naming:
`WF-XX — Name — vN`

Use:
- clear trigger;
- normalization;
- validation;
- business logic;
- output contract;
- audit event;
- error branch.

## Credential rules

Credentials must be referenced through n8n credential storage. Never hard-code:
- OpenAI API keys;
- WooCommerce secrets;
- Meta secrets;
- Supabase service keys.

Never place credentials in LLM prompts.

## Error handling

For each workflow:
- expected business error → typed response;
- transient upstream error → bounded retry;
- unknown execution → reconciliation;
- security error → quarantine/escalation;
- programming error → alert and dead-letter.

## Production execution settings

Choose conservative concurrency and rate limits according to:
- WooCommerce capacity;
- Meta limits;
- OpenAI limits;
- expected conversation volume.

Load test before increasing concurrency.
