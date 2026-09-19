# Configuration

Suggested:
- `RENDERER_MAX_CHARS=1500`
- `RENDERER_MAX_REGEN=2`

## Script policy

If:
`language=tn` + `script=latin`

then the final output must contain no Arabic Unicode characters.

Examples of valid Latin/Arabizi output:
- `Ey, taille 42 mawjouda.`
- `es-souma 189 DT.`
- `Nnajem n3awnek tkemmel commande.`

Arabic-script output is allowed only when the trusted context explicitly requests Arabic script.

## Public channels

For Facebook/Instagram public comments:
- no price
- no phone
- no address
- no order number/status
- no customer-specific data

Move sensitive details to private messages.
