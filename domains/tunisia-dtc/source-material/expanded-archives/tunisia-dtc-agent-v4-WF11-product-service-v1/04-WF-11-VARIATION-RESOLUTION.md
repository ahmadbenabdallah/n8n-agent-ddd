# WF-11 Variation Resolution

Variable products require deterministic option resolution.

Input may contain:
- product ID;
- selected attributes;
- customer natural-language option such as size 42;
- variation ID if already known.

Resolution:
1. identify canonical product;
2. retrieve allowed attributes/variations;
3. normalize customer option values;
4. match exact canonical variation where possible;
5. reject ambiguous matches;
6. return variation ID and current facts;
7. if no match, return structured `VARIATION_NOT_FOUND`.

Examples:
- "taille 42" must resolve against actual WooCommerce variation attributes.
- Never assume size 42 exists because the customer requested it.
- Never substitute another size silently.
