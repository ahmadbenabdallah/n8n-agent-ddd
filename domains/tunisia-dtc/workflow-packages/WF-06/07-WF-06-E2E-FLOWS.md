# WF-06 End-to-End Support Flows

## A — Order status

Customer:
“win waslet lcommande mte3i?”

1. WF-04 → order_status
2. WF-06 → WF-07
3. WF-07 checks identity/order scope
4. WF-20 retrieves current order status
5. WF-06 receives minimum verified fields
6. WF-16 renders answer

## B — Website-originated order

Customer ordered from website and later contacts Messenger.

1. WF-02 resolves Messenger identity.
2. If no linked commerce identity, WF-07 performs bounded candidate discovery.
3. Verification establishes order scope.
4. Scope is persisted.
5. Future protected status requests use the stored scope.

## C — Return request

Customer:
“nheb nrajja3 lproduit.”

1. WF-06 loads current return policy.
2. Determine whether order/item facts are needed.
3. WF-07 supplies scoped facts if authorized.
4. Explain applicable policy.
5. Escalate exceptions/review cases.

## D — Payment dispute

Customer:
“paiement tkhassar w bech na3mel chargeback.”

1. WF-06 classifies `payment_dispute`.
2. No payment mutation.
3. WF-08 creates/updates human case.
4. Conversation enters human ownership/safe waiting according to case state.
5. Renderer sends controlled acknowledgement.

## E — Damaged product

Customer:
“produit وصلني مكسور.”

1. Classify complaint/damaged.
2. Gather minimum facts.
3. Apply approved policy.
4. If review required → WF-08.
5. No automatic refund promise unless explicitly authorized by policy/workflow.

## F — Human request

Customer:
“nheb نحكي مع humain.”

1. WF-06 → WF-08.
2. Human case created idempotently.
3. Acknowledgement state = HANDING_TO_HUMAN.
4. Human ownership begins when assignment/takeover state is confirmed.

## G — Live backend unavailable

Customer asks current order status.

1. WF-06 → WF-07.
2. Live lookup unavailable.
3. Do not use stale history as current status.
4. Return safe acknowledgement/recovery path.
5. Escalate when required.

## H — Public comment

Customer posts order question in public comments.

Expected:
- no order lookup result publicly
- no PII
- redirect to DM
