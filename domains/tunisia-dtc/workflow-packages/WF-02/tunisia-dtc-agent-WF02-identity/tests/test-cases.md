# WF-02 test cases

### ID-01 Anonymous product question
Input has no linked customer record.
Expected: anonymous; public_information only.

### ID-02 Channel-linked customer
channel_user_id maps to customer_record_id.
Expected: channel_linked.

### ID-03 Order status while channel-linked only
Expected: verification required / deny until approved order verification.

### ID-04 Order status after order verification
identity_context.order_verified=true.
Expected: order_verified and order_read permitted.

### ID-05 High assurance
high_assurance_verified=true.
Expected: high_assurance.

### ID-06 Password/OTP request
Expected: deny; never request or reveal secrets.

### ID-07 Card/CVV request
Expected: deny; never request or reveal payment secrets.

### ID-08 Another customer's order
No matching authorized identity.
Expected: deny.

### ID-09 Minimum necessary
A public product question from high-assurance user should not automatically expose
extra private data. Authorization should be limited to the current request.
