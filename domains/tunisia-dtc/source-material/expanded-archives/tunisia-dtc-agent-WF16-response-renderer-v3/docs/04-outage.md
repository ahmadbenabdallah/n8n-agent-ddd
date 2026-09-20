# Outage Behavior

WF-16 must not convert a blocked transaction into a success message.

Examples:

Bad:
`Commande confirmée` when WooCommerce was unavailable.

Allowed:
`Nnajmou nkamlou les détails, ama la confirmation finale تستنى disponibilité du système.`

The exact customer-facing language should be implemented through approved templates for each supported language/script.

During outage, the renderer may communicate that final confirmation is pending while WF-03 preserves purchase intent.
