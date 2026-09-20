<?php
/**
 * Plugin Name: Tunisia DTC Agent Commerce Adapter
 * Description: Minimal WooCommerce adapter endpoints for a controlled AI commerce integration.
 * Version: 1.0.0
 * Requires Plugins: woocommerce
 *
 * IMPORTANT:
 * - This plugin does NOT expose arbitrary WooCommerce access.
 * - n8n should authenticate at the reverse proxy or use a dedicated application credential.
 * - Keep this endpoint private to your n8n server/network.
 */

if (!defined('ABSPATH')) exit;

add_action('rest_api_init', function () {
    register_rest_route('dtc-agent/v1', '/health', [
        'methods' => 'GET',
        'permission_callback' => 'dtc_agent_permission',
        'callback' => function () {
            return new WP_REST_Response(['ok'=>true,'service'=>'dtc-agent-commerce'], 200);
        }
    ]);

    // Reserved contract for a future server-side cart implementation.
    // Current WF-20 uses WooCommerce REST API for products/orders and keeps cart
    // state in the agent layer until this endpoint is explicitly enabled.
    register_rest_route('dtc-agent/v1', '/cart', [
        'methods' => ['GET','POST','PUT','DELETE'],
        'permission_callback' => 'dtc_agent_permission',
        'callback' => 'dtc_agent_cart_not_implemented'
    ]);
});

function dtc_agent_permission(WP_REST_Request $request) {
    /*
     * Recommended production pattern:
     * 1) Restrict /dtc-agent/* at nginx/Cloudflare/VPN to the n8n host.
     * 2) Require a separate shared secret or mTLS at the edge.
     * 3) Do NOT accept a secret in a customer message or workflow input.
     *
     * This callback intentionally fails closed until you implement the edge
     * authentication method appropriate for your infrastructure.
     */
    return new WP_Error(
        'dtc_agent_not_configured',
        'Commerce adapter authentication is not configured.',
        ['status'=>503]
    );
}

function dtc_agent_cart_not_implemented() {
    return new WP_Error(
        'dtc_agent_cart_not_configured',
        'Server-side WooCommerce cart adapter is not enabled.',
        ['status'=>501]
    );
}
