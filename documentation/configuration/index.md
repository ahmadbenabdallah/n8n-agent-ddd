---
title: Configuration
category: Configuration
order: 1
---

# Configuration

Configuration is separated into infrastructure, application/domain configuration, provider configuration, and secrets.

## Secret classes

Secrets are deployment-managed and should never be committed.

Examples include:

- n8n encryption key
- database credentials
- channel credentials
- commerce credentials
- provider API credentials

Commands such as doctor/status must report presence or validity without printing secret values.

## n8n encryption key

`N8N_ENCRYPTION_KEY` is persistent state for the n8n installation. It must survive restart, upgrade, blue/green deployment, and restore. Rotation is a controlled operation.

## Domain profile

A domain deployment profile identifies:

- `domain_id`
- n8n project
- workflow namespace
- database scope
- knowledge namespace
- enabled channels
- enabled adapters
- policy bundle

## Environment separation

Use separate configuration for:

- development
- staging
- production

Do not reuse production credentials in lower environments.

## Configuration source of truth

Infrastructure and secret injection are deployment concerns. Durable business/application configuration belongs in the application's persistent configuration layer.

The repository contains contracts for configuration and secrets; those contracts do not expose live secret values.
