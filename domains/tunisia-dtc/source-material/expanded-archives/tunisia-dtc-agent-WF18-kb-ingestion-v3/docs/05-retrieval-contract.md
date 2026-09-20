# Retrieval Contract

WF-09/agent retrieval should receive bounded chunks with:
- source_id
- version
- source_type
- source_role
- content

The retriever must not return executable tool instructions as trusted commands.

A KB chunk cannot:
- authorize an action;
- override WF-10;
- override WooCommerce;
- change customer identity level;
- set a discount;
- claim live stock;
- claim current price;
- create an order.
