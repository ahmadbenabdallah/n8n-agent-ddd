# Post-Create Verification

Never trust a successful POST/create response alone.

After creation:
1. retrieve the order by ID through WF-20;
2. verify the order belongs to the expected customer/session scope;
3. verify line items and quantities;
4. verify total/currency;
5. verify payment method is COD;
6. verify payment status is not paid;
7. return only customer-safe fields.

If verification fails, WF-15 must not claim successful order creation.
The incident should be surfaced to WF-08/WF-17 for operational handling.
