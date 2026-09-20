# Sales During WooCommerce Outage

The agent continues the conversation using KB while preserving purchase intent in Supabase.

Example:
`Nheb Nike Air Max 95 taille 42`

The agent may explain stable product information, ask for missing customer details, and persist:
- product reference
- requested variant/size
- quantity
- name/phone/address explicitly provided
- purchase intent

It must not claim live stock, live price, coupon validity, checkout, order creation, or payment.

Later:
`Ok nheb nkamel`

WF-02 finds the same customer and WF-03 restores context. Once WooCommerce is healthy, WF-11/WF-20 fetch current live facts and WF-14/WF-15 can resume only after fresh validation.
