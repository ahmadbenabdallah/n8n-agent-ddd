# WF-07 — Order Service

WF-07 is the **read-only order-status boundary** between support orchestration and the commerce/transaction system.

It does not itself contain a store API credential. Instead it creates a bounded transaction query for the configured commerce adapter and accepts only a result explicitly marked as verified and owned by the authorized customer.

## Position

WF-06 Support Engine → **WF-07 Order Service** → commerce/order adapter → WF-09 / WF-16.

For a production integration, replace the transaction-result placeholder with a credentialed HTTP Request or dedicated connector **inside this workflow**, while preserving the same query/result contract.

## Core security rule

`order_verified` or `high_assurance` identity is required for order-specific disclosure.

An order number, customer name, phone number, screenshot, or customer assertion is not sufficient authorization by itself.
