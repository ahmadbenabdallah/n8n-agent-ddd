# Authorization matrix

| Action | Anonymous | Channel linked | Order verified | High assurance |
|---|---:|---:|---:|---:|
| none | ✓ | ✓ | ✓ | ✓ |
| cart_add | — | ✓ | ✓ | ✓ |
| cart_remove | — | ✓ | ✓ | ✓ |
| cart_update | — | ✓ | ✓ | ✓ |
| cart_clear | — | ✓ | ✓ | ✓ |
| checkout_start | — | ✓ | ✓ | ✓ |
| checkout_confirm | — | — | ✓ | ✓ |

This matrix is a baseline and must be aligned with the actual commerce system's authentication model.
