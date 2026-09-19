# Tunisia DTC Agent System FINAL v4 — WF-11 Product Service

WF-11 is the product information and product-read service.

Authority model:
- WF-11 owns product-service orchestration.
- WooCommerce remains authoritative for live product price, stock, purchasability and variation state.
- WF-20 is the only privileged WooCommerce integration boundary.
- WF-10 authorizes protected actions.
- WF-09 may propose; it cannot execute or authorize.
- WF-16 renders only verified results.

WF-11 supports product discovery, product questions, comparisons, availability and product context required by downstream cart/checkout flows.
