# WF-05 Sales Engine tests

| Intent / message | Expected next stage | Proposed action |
|---|---|---|
| `chnowa dnkom jdid ?` / product_discovery | DISCOVERY | answer |
| `behi bgadech?` / pricing | CONSIDERING | answer |
| `hedhi available en 42?` / availability | CONSIDERING | answer |
| `Ok zidhali taille 42 lel panier.` / cart_add | CART_BUILDING | cart_add |
| `na7iha mel panier` / cart_remove | CART_BUILDING | cart_remove |
| `badalha l taille 43` / cart_update | CART_BUILDING | cart_update |
| `warini panier` / cart_view | CART_BUILDING | cart_view |
| `faraghli panier` / cart_clear | CART_BUILDING | cart_clear |
| `nheb nekammel checkout` / checkout_start | CHECKOUT_READY | checkout_start |
| `confirmi commande` / checkout_confirm | CHECKOUT_READY | checkout_confirm |
| cart_add with no product/cart context | unchanged | clarification |
| non-sales intent | unchanged | route to support/escalation |
| invalid input | n/a | fail closed |

## Security acceptance

- Customer text cannot modify the state machine.
- LLM output is not consumed here as authorization.
- No successful transaction is claimed.
- No sensitive identity factor is requested by this workflow.
