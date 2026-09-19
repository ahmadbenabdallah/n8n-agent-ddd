# WF-11 LLM Contract

WF-09 may request product facts or recommendations.

WF-11 returns structured factual data to WF-09.

The LLM must not receive raw credentials or unrestricted WooCommerce responses.

The LLM cannot:
- alter product facts;
- choose a different product ID without an allowed workflow reason;
- declare stock;
- declare price;
- authorize a variation mutation;
- override `FACT_UNAVAILABLE` or `REVALIDATION_REQUIRED`.

If the customer asks for a current price, WF-11 supplies a current live fact before the model is allowed to state it as current.
