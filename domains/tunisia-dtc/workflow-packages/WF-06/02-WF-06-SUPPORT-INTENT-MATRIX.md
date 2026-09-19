# WF-06 Support Intent Matrix

| Intent | Required source | Typical action | Escalation |
|---|---|---|---|
| shipping | approved shipping policy | answer | if exception/complaint |
| payment | approved payment policy | answer | payment dispute |
| order_status | live order service | WF-07 | identity uncertainty/failure |
| return_exchange | current return policy + order facts if needed | explain/process path | policy exception/damaged item |
| complaint | policy + relevant live facts | resolve if deterministic | serious/repeated complaint |
| payment_dispute | transaction/order context | human case | mandatory |
| human_request | none/minimal | WF-08 | mandatory handoff |
| safety | approved safety policy | safe guidance | mandatory where safety concern |
| security_suspicion | security policy + scoped facts | restrict + escalate | mandatory when material |

## Order-specific precedence

If a customer asks:

“win waslet lcommande?”

route to WF-07 rather than answering from memory.

If:

“3lech lcommande mazelt ma wsoltech?”

use WF-07 for live order state, then apply support/complaint policy.

## Return example

“Najjem nrajja3ha?”

WF-06 should:
1. retrieve current return policy
2. determine whether order/item facts are required
3. avoid promising eligibility until conditions are verified

## Payment example

“Khallit commande ama paiement mazal ma tconfirmach?”

Do not infer payment status.
Retrieve authoritative transaction/order state.

## Complaint example

“Produit وصلني مكسور.”

Classify as damaged/defective.
If review is required, route to human case.
Do not invent refund/replacement outcome.

## Human request

Any explicit human request bypasses ordinary support persuasion and goes to WF-08.
