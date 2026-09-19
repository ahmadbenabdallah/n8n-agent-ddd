# Tunisia DTC Agent System FINAL v4 — WF-07 Order Service

Version 4 incremental update for WF-07.

Focus:
- secure order discovery and scoped order access;
- website-originated WooCommerce orders later accessed through Messenger;
- explicit separation of discovery, verification, authorization, execution, and live-state retrieval;
- multiple-match and identity-collision handling;
- fresh WooCommerce reads through WF-20;
- human-ownership and fail-closed behavior.

WF-07 does not itself grant authorization. WF-10 remains the hard authorization boundary and WF-20 remains the privileged WooCommerce boundary.
