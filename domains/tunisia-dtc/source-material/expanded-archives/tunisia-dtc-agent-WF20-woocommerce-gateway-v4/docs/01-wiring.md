# v4 Wiring

`Validate Gateway Contract → Health Operation Bypass?`

- health operation → `WooCommerce REST Health` → normalization
- all other operations → `WooCommerce REST Health — Preflight` + original request → `Merge Request + WC Health` → `Commerce Availability Gate` → `Operation Router`

The preflight health request uses `continueRegularOutput` so an unavailable WooCommerce endpoint is converted into a deterministic gateway result instead of terminating the workflow.

Verify HTTP credential, base URL, timeout, and node field mappings in the installed n8n version before production.
