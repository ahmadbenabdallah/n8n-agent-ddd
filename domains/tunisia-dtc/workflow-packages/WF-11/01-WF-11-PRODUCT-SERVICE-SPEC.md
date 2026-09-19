# WF-11 Product Service Specification

## Responsibilities
WF-11:
- retrieves product/variation data;
- normalizes WooCommerce product data into a safe internal contract;
- supports search/discovery;
- retrieves current product facts when freshness matters;
- resolves variations/options;
- returns bounded product context for recommendations;
- provides product/variant facts to WF-12 and WF-14;
- reports authoritative failures without inventing replacements.

## Non-responsibilities
WF-11 does not:
- authorize mutations;
- create orders;
- modify carts;
- determine payment state;
- grant identity/order scope;
- execute arbitrary WooCommerce requests;
- expose raw WooCommerce credentials;
- let the LLM decide final price/stock.

## Source of truth
For live facts, WooCommerce is authoritative.
Supabase/RAG may contain stable descriptive content but cannot override live commerce state.
