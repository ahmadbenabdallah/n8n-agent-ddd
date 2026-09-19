# WF-00 test cases

## T01 — Meta verification success
GET:
`?hub.mode=subscribe&hub.verify_token=<correct>&hub.challenge=12345`
Expected: HTTP 200 and body `12345`.

## T02 — Meta verification failure
Wrong token.
Expected: HTTP 403.

## T03 — Missing signature
POST Messenger event without X-Hub-Signature-256.
Expected: rejected in production mode.

## T04 — Echo event
A Messenger event marked `is_echo=true`.
Expected: not routed as a customer message.

## T05 — Normal Tounsi/Arabizi text
Text:
`chnowa 3andkom jdid ?`
Expected canonical text preserved exactly.
No language conversion occurs here.

## T06 — Arabic text
Text:
`شنوة عندكم جديد؟`
Expected canonical text preserved exactly.

## T07 — Attachment
Attachment event.
Expected `message_type=attachment`, attachments preserved, no invented text.

## T08 — Duplicate
Same `message_id`.
Expected downstream idempotency handling in the next workflow.
WF-00 creates the stable `idempotency_key`.

## T09 — Malformed event
Missing sender or message ID.
Expected rejected and not routed to business logic.
