# Action Audit Lifecycle

Every consequential action should produce correlated events:

```text
authorization_requested
    |
    +--> denied
    |
    +--> authorized
             |
             v
       execution_started
             |
       +-----+------+
       |            |
    succeeded     failed
       |            |
       v            |
 verification       |
       |            |
   +---+---+        |
   |       |        |
 verified unknown  |
   |       |        |
   v       v        v
complete reconciliation
```

Important distinctions:
- authorization is not execution;
- execution success is not verification;
- unknown is not failure;
- order creation is not payment;
- payment state must come from WF-15/commerce truth.

WF-17 must preserve these distinctions in analytics.
