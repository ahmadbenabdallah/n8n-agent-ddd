# Tunisia DTC Agent — WF-20 WooCommerce Gateway v4

Production implementation package for **WF-20 WooCommerce Gateway**.

Core invariant:

> **WF-20 is the only privileged WooCommerce integration boundary. It executes only requests that have already passed WF-10 authorization, and it verifies consequential results against WooCommerce.**

Architecture:

```text
WF-10 Authorization
        |
        v
WF-20 WooCommerce Gateway
        |
        +--> WooCommerce REST API v3
        +--> WooCommerce Store API (only for explicitly supported customer/cart flows)
        |
        v
verified commerce result
        |
        v
service workflow / WF-16 renderer / WF-17 audit
```

WF-20 is not:
- an LLM tool;
- an authorization engine;
- a customer identity authority;
- a business-policy engine;
- a replacement for WF-10;
- a place to store payment credentials.

The gateway must reject calls without a valid short-lived WF-10 authorization record.
