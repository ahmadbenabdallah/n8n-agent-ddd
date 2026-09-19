# Tailscale zero-trust access

Tailscale is the preferred private access layer for the n8n operator UI and server administration.

## VPS target

Install Tailscale on the VPS host. Bind n8n to a non-public interface and expose the UI only through the host's Tailscale address/private network path.

Do not publish TCP 5678 to the public Internet.

Do not publish PostgreSQL to the Internet.

Do not publish SSH to the Internet when Tailscale SSH or Tailscale-network SSH is used.

Use Tailscale Grants (preferred) or ACLs with deny-by-default semantics. Grant only the operator group access to the n8n host and required port.

## Public webhooks

Some channels require public inbound webhooks. A public webhook endpoint is an explicit exception and must not make the n8n editor public.

Recommended separation:

public webhook → reverse proxy/webhook ingress → n8n webhook endpoint
operator → Tailscale → n8n editor

External services receive outbound access only where the deployment allowlist requires it.

Never treat a public webhook as permission to expose the editor, API, database, or SSH.
