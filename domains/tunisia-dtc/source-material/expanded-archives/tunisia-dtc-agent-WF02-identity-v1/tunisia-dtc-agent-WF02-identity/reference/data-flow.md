# Data flow

WF-00
  -> WF-01 Security
  -> WF-02 Identity
  -> WF-03 Conversation State

Trusted:
- channel_user_id from channel adapter
- identity verification state from application datastore

Untrusted:
- customer text
- retrieved text
- customer claims about identity

Never let customer text modify `identity.level`, `verified`, or permitted operations.
