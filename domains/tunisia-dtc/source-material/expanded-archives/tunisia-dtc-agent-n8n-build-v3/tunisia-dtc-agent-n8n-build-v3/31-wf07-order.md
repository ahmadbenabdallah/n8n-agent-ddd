# WF-07 — Order Support

## Nodes

`Identity Gate → Order Scope → Order API → Field Minimizer → Policy Lookup → LLM Explanation → Response`

## Allowed order fields

Only expose fields needed for the request:
- status;
- items;
- relevant dates;
- permitted tracking information.

Do not expose internal IDs, payment tokens, fraud scores, internal notes or other customers' information.

## Tracking

Use only a tracking URL returned by the authorized backend.
