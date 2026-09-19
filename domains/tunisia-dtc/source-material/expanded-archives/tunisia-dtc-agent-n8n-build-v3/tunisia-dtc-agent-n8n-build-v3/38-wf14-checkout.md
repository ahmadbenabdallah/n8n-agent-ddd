# WF-14 — Checkout

## Flow

`Current Cart → Revalidate Price/Inventory/Promotion → Create/Fetch Checkout → Verify URL Origin → Return URL`

Only accept checkout URLs returned by the authorized commerce platform.

Do not construct URLs from templates.

## Customer message

The channel renderer may say:
- Tounsi: `Hakka l-cart mte3ek جاهز. تنجم تكمل commande من هنا: ...`
- French: `Votre panier est prêt. Vous pouvez finaliser la commande ici : ...`

The URL must be the verified backend result.
