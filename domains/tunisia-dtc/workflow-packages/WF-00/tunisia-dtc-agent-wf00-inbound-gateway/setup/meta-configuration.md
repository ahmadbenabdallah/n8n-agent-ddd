# Meta / Facebook Page setup

## 1. Meta Developer App

Create/use a Meta app connected to the Facebook Page.

You need:
- App ID
- App Secret
- Page ID
- Page Access Token
- Verify Token (your own random secret)

Store secrets in n8n credentials/environment. Never put them in the system prompt or KB.

## 2. n8n webhook URL

After importing the workflow, open `META Verify — GET` and `META Events — POST`.

Use the Production URL, not the Test URL, when registering the Meta callback.

Both nodes use:

`facebook-messenger/webhook`

If your n8n version rejects two webhook nodes with the same path, use one webhook with
multiple HTTP methods enabled, or create separate GET/POST paths and put a reverse proxy
in front of them. Keep the external Meta callback stable.

## 3. Meta callback verification

Register:
- Callback URL = n8n Production URL
- Verify Token = exactly the value in `META_VERIFY_TOKEN`
- Subscribe to the Page messaging events required by your app

Meta will send:
`hub.mode`
`hub.verify_token`
`hub.challenge`

The GET branch returns the challenge only when the verify token matches.

## 4. POST signature

Messenger POST requests include `X-Hub-Signature-256`.

The production implementation must verify:
HMAC-SHA256(raw_request_body, META_APP_SECRET)

Compare the resulting digest with the header's `sha256=` value using a timing-safe comparison.

The workflow currently marks the verification boundary explicitly and fails closed if
the signature is missing.

## 5. Development

For local testing only:
`ALLOW_UNVERIFIED_META_WEBHOOK=true`

Never use this in production.
