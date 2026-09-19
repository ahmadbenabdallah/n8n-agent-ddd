# Health & Schema Drift

WF-19 may monitor WF-20.

Checks:
- WooCommerce connectivity;
- API latency;
- authentication;
- expected HTTP status distribution;
- response schema;
- required fields;
- Store API availability where enabled.

Schema drift:
1. detect unexpected response;
2. stop affected operation if required;
3. alert;
4. preserve raw response only under controlled diagnostics policy;
5. update normalization contract;
6. regression test;
7. redeploy.

Never silently map an unexpected response into a successful business result.
