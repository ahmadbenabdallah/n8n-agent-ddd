# Workflow Wiring Matrix

| Caller | WF-20 operation |
|---|---|
| WF-07 | get_order |
| WF-11 | get_product / get_products / get_variation |
| WF-12 | cart_view/add/remove/update/clear |
| WF-13 | coupon_validate |
| WF-14 | checkout_validate |
| WF-15 | transaction_preflight / create_cod_order / get_order |
| WF-19 | health |
| WF-20B | observational event processing outside mutation path |

WF-20 is the only workflow that should hold WooCommerce integration credentials.
