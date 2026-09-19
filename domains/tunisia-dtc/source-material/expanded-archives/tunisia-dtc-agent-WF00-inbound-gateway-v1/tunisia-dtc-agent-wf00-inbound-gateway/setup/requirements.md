# Requirements

## n8n
- Current supported n8n version
- Production HTTPS URL
- Production webhook URL reachable from Meta
- Environment variables available to Code nodes

## Meta
- Meta Developer App
- Facebook Business Page
- Page access token
- App secret
- Verify token
- Messenger/Page messaging permissions approved as required by Meta

## Security
- HTTPS
- Secret storage
- Raw request body available for signature verification
- Production HMAC-SHA256 verification
- Logging that does not expose tokens or signatures

## Downstream
WF-00 expects WF-01 to consume the canonical event later.
Do not connect business logic directly to this webhook.
