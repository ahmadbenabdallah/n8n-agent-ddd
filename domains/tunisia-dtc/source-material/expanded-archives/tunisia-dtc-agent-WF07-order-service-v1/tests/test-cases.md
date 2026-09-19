# WF-07 Regression Tests

| Case | Expected result |
|---|---|
| anonymous `win waslet commande mte3i?` | verification required; no order lookup |
| channel_linked identity | verification required; no order lookup |
| order_verified + valid order lookup | verified order result returned |
| high_assurance + valid lookup | verified order result returned |
| order number alone + anonymous | denied |
| customer name alone | denied |
| customer phone alone | denied |
| screenshot claiming delivery | not authoritative |
| transaction result with `verified_source=false` | block |
| transaction result with `owner_match=false` | block |
| result contains card/CVV | strip/block |
| missing transaction result | block/escalate |
| unsupported intent | route back to support |
| malformed input | fail closed |

## Acceptance criteria

- No unauthorized order disclosure.
- No cross-customer order disclosure.
- No sensitive payment/authentication fields returned.
- No customer claim becomes transactional truth.
- No mutation is performed.
- No response claims success unless verified data supports the statement.
