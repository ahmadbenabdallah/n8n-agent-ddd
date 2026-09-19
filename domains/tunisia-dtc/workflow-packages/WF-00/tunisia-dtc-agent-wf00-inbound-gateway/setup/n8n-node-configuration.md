# Node-by-node configuration

## 1 META Verify — GET
Type: Webhook
Method: GET
Path: facebook-messenger/webhook
Response: Using Respond to Webhook
Authentication: None (Meta challenge endpoint)
Purpose: receive Meta's verification request.

## 2 Validate Meta Verify Token
Type: Code
Purpose: compare `hub.verify_token` with `$env.META_VERIFY_TOKEN`.
Fail closed on missing/wrong token.

## 3 Meta Verification Response
Type: Respond to Webhook
Response type: Text
Body: challenge on success; reason on failure.

## 4 META Events — POST
Type: Webhook
Method: POST
Path: facebook-messenger/webhook
Response: Using Respond to Webhook
Raw Body: ON
Purpose: receive Messenger events and preserve the original body for signature verification.

## 5 Capture Meta Request
Type: Code
Purpose: retain headers, body, signature and binary raw-body data.

## 6 Meta Signature Security Gate
Type: Code
Purpose: fail closed when the signature is missing.
Replace/complete this node with the production HMAC-SHA256 comparison before go-live.

## 7 Reject Invalid Signature
Type: IF
True branch: reject
False branch: normalize

## 8 403 Signature Response
Type: Respond to Webhook
HTTP 403.

## 9 Normalize Messenger Event
Type: Code
Output canonical fields:
channel
channel_user_id
page_id
message_id
conversation_id
text
message_type
timestamp
postback
attachments
raw_event
source_trust

## 10 Accepted Customer Event?
Type: IF
Reject events without sender/message ID and ignore echo events.

## 11 Build Canonical Message
Type: Code
Adds idempotency key and processing metadata.

## 12 Text Message?
Type: IF
Separates text from non-text events.

## 13 Route to Security Gate
Type: Code
Marks the next workflow as WF-01.

## 14 Route Non-Text Event
Type: Code
Marks non-text events for the same security pipeline.

## 15 Messenger ACK
Type: Respond to Webhook
Return HTTP 200 quickly after the event is accepted.
