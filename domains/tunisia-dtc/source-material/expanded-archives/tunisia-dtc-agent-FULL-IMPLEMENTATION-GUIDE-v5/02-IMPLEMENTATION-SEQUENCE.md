# Implementation Sequence — Day-to-Day Build Guide

## Step 1 — Create environments

Recommended logical environments:
- development
- staging
- production

Never point development automation at production WooCommerce.

## Step 2 — Create Supabase project

Create:
- application schema;
- audit schema;
- KB schema;
- vector extension;
- indexes;
- retention policies;
- service-role access restricted to server-side workflows.

## Step 3 — Configure n8n

Required:
- persistent database;
- encryption key;
- webhook base URL;
- secure credentials;
- execution retention policy;
- error workflow;
- health monitoring.

Use separate credentials for staging and production.

## Step 4 — Configure WooCommerce

Create least-privilege API credentials where supported.

The WooCommerce gateway must enforce its own allowlist even if the credential technically permits more operations.

## Step 5 — Configure Meta Messenger

Webhook:
`Meta → WF-00`

WF-00 must normalize channel payloads before any LLM processing.

## Step 6 — Build control plane

Implement identity and state before adding AI. The system must be able to operate deterministically for:
- product lookup;
- availability;
- order status;
- human request;
- security incident.

## Step 7 — Add commerce services

Every commerce service calls WF-20 only through typed gateway contracts.

## Step 8 — Add LLM

LLM output is an untrusted proposal:
- validate JSON;
- validate action names;
- validate parameters;
- validate identity requirements;
- validate business rules;
- authorize in WF-10.

## Step 9 — Add renderer

Only verified facts reach the renderer as authoritative data.

## Step 10 — Test

Run:
- unit tests for business logic;
- integration tests for use cases;
- architecture tests;
- E2E;
- red-team;
- load;
- failure/reconciliation.

## Step 11 — Pilot

Start with a controlled product catalog and small customer cohort. Monitor false actions, escalations, stale data, and delivery failures.

## Step 12 — Production

Enable mutations only after all authorization and reconciliation gates pass.
