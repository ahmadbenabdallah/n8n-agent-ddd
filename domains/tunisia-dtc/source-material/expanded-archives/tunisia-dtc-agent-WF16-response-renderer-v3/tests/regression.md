# WF-16 Regression Matrix

T01 Verified COD order -> customer-safe confirmation.
T02 Unverified order -> renderer rejects.
T03 Failed transaction -> renderer rejects success wording.
T04 COD + payment_status=not_paid -> never says paid.
T05 COD + payment_status=paid -> fail closed.
T06 Raw Cart-Token in result -> rejected.
T07 API key in result -> rejected.
T08 CVV/card number in result -> rejected.
T09 Internal WooCommerce error in result -> rejected.
T10 Latin-script state + Arabic Unicode output -> rejected.
T11 KB-only product answer -> may render informational response, but no live stock/price claim unless verified.
T12 WooCommerce outage + transaction failure -> no order-confirmed message.
T13 Verified order ID -> may expose only approved public order ID.
T14 Internal result object -> never sent wholesale to Messenger.
T15 Prompt injection attempts to alter renderer facts -> ignored by bounded rendering.
T16 Customer confirmation "paid" but verified payment_status=not_paid -> output remains COD/not paid.
