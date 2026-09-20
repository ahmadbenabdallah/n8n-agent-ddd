# WF-20 v2 — Native WooCommerce Adapter

## Objective

Use n8n's native WooCommerce integration as the primary commerce interface, with HTTP Request only where the native node is not sufficient.

Current n8n documents WooCommerce support for Customer, Order and Product resources and Create/Get/Get Many/Update/Delete operations as applicable. WooCommerce Trigger supports coupon, customer, order and product events including `order.created`, `order.updated`, `product.created`, and `product.updated`.

Official references:
- https://n8n.io/integrations/woocommerce/
- https://n8n.io/integrations/woocommerce-trigger/

## Target

Commerce: WooCommerce
Payment: COD
Shipping: manual
n8n: self-hosted
Channel: Messenger

## Architecture

LLM proposes
→ WF-10 authorizes
→ WF-12/14/15 orchestrate commerce
→ WF-20 executes against WooCommerce
→ verify
→ WF-16 renders
→ WF-17 audits

WF-20 is NOT an authorization layer.

## Native-first policy

Use the WooCommerce node for:
- product reads
- product lists
- order creation
- order reads
- supported order updates

Use HTTP Request only for a documented capability gap or health endpoint.

Do not create a custom WordPress plugin for v2.

## Cart reality

WooCommerce's native n8n node exposes Product/Order/Customer resources, not a generic agent conversation cart abstraction.

Therefore:
- WF-12 remains the cart/state owner.
- WooCommerce is the product/order system of record.
- At checkout, WF-14 snapshots the agent cart and revalidates product/variation/stock/price.
- WF-15 creates the COD WooCommerce order.
- WF-20 retrieves/verifies the order before success is exposed.

Do NOT pretend WooCommerce order drafts are a cart.

## COD

Order creation must use:
- payment method = COD
- set paid = false
- no card data
- no OTP/CVV/PIN/password

Order created does not mean cash collected.

## Shipping

Manual. No automatic delivery ETA or dispatch claim unless a verified policy or shipping system supplies it.
