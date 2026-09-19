# Node-by-node configuration

1. **Execute Workflow Trigger** — called by WF-03.
2. **Validate Router Input** — validates required canonical fields.
3. **Router Input Valid?** — fail-closed branch.
4. **Reject Invalid Router Input** — creates a safe clarification object.
5. **Normalize + Language Script** — Unicode normalization plus lightweight Tounsi/French/Arabic/English signal detection. Language and script are separate.
6. **Deterministic Intent Rules** — first-pass intent classifier using explicit patterns.
7. **Cart + Checkout Overrides** — resolves high-value cart/checkout phrases before routing.
8. **Clarification Required?** — confidence/ambiguity gate.
9. **Build Clarification Route** — prevents tool use when intent is unclear.
10. **Route by Intent** — maps intent to sales/support/escalation/off_topic.
11. **Build Intent Contract** — emits the downstream contract.
12. **Safe Unroutable Route** — fail-closed fallback.

## Important

The Code nodes are deliberately explicit so the rules can be reviewed and tested. For production, keep the rule list in source control and add regression tests whenever a phrase causes a misclassification.
