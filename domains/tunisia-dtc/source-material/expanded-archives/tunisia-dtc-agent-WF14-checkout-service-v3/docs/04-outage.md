# Outage Behavior

When WooCommerce is unavailable:

- no checkout snapshot is created;
- no current price/stock/availability claim is made;
- no coupon is treated as valid;
- no order can be created;
- WF-03 may preserve purchase intent and customer details;
- the sales conversation can continue using approved KB information.

When commerce recovers, WF-11/WF-12/WF-13 and WF-14 must use fresh live state.
