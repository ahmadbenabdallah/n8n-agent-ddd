# WF-00 — Inbound Gateway — Facebook Messenger

## Goal

Receive Messenger events from a Facebook Business Page, verify Meta's webhook handshake,
reject unsigned/suspicious requests, normalize the event into the agent's canonical message
contract, and return a fast HTTP acknowledgement.

## Nodes

1. META Verify — GET
2. Validate Meta Verify Token
3. Meta Verification Response
4. META Events — POST
5. Capture Meta Request
6. Meta Signature Security Gate
7. Reject Invalid Signature
8. 403 Signature Response
9. Normalize Messenger Event
10. Accepted Customer Event?
11. Build Canonical Message
12. Text Message?
13. Route to Security Gate
14. Route Non-Text Event
15. Messenger ACK

## Why this workflow does not contain the AI

WF-00 is a channel adapter only. It must not decide product answers, promotions,
identity authorization, cart operations, checkout, or customer-facing business logic.

The canonical event leaves this workflow and is processed by WF-01 onward.

## Important production point

Meta's POST signature is calculated from the raw request body. n8n's Webhook node
supports Raw Body and exposes request headers/body; use that capability for HMAC verification.
The included security gate deliberately fails closed unless the signature is verified or
the explicit development flag `ALLOW_UNVERIFIED_META_WEBHOOK=true` is set.

Do NOT enable that flag in production.
