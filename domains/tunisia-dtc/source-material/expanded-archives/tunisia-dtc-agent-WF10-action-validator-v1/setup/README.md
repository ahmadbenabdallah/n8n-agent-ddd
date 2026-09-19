# WF-10 — Action Validator

This is the hard authorization boundary.

**WF-09 proposes → WF-10 authorizes → service executes → post-action verification.**

WF-10 must be deterministic. Do not place an LLM inside the authorization path.

Supported action proposals:
- none
- cart_add
- cart_remove
- cart_update
- cart_clear
- checkout_start
- checkout_confirm

The workflow returns an authorized action contract but does not execute the commerce operation itself.
