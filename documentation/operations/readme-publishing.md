---
title: ReadMe Publishing
category: Operations
order: 3
---

# ReadMe Publishing

Public documentation is maintained in Git and published automatically to ReadMe by GitHub Actions.

## Boundary

Only `documentation/` is published by the repository's ReadMe workflow.

Internal `docs/` content is deliberately excluded.

## GitHub configuration

Configure:

- `README_API_KEY` as a repository/environment secret
- `README_VERSION` as a repository variable

Never commit the API key.

## Workflow

The workflow:

1. checks out the repository
2. invokes `readmeio/rdme@v10`
3. uploads `./documentation`
4. authenticates with `README_API_KEY`
5. publishes to the configured ReadMe branch/version

## Trigger

Publishing runs after approved changes reach `main` that affect public documentation or release metadata. It can also be manually dispatched.

## Source of truth

Git remains authoritative. ReadMe is the public publishing surface.
