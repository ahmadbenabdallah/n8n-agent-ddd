---
title: Documentation
category: Getting Started
order: 0
---

# Documentation

This is the **public documentation source** for n8n Agent DDD.

The repository deliberately separates public documentation from internal engineering documentation:

- `documentation/` → safe, curated user/developer documentation published to ReadMe.
- `docs/` → internal architecture, certification evidence procedures, operational runbooks, and engineering notes. It is **not** published to ReadMe.

Git is the source of truth. ReadMe is the public publishing layer.

## Start here

- [Getting Started](../documentation/getting-started/index.md)
- [Installation](../documentation/installation/index.md)
- [Configuration](../documentation/configuration/index.md)
- [Deployment](../documentation/deployment/index.md)
- [Operations](../documentation/operations/index.md)
- [Developer Guide](../documentation/development/index.md)

## Privacy boundary

Public docs must not expose:

- credentials or secrets
- internal hostnames or infrastructure details
- customer/order data
- private evidence artifacts
- internal security test payloads
- unpublished incident or operational details
- internal agent prompts or private control-plane state

Internal documentation remains in `docs/`.
