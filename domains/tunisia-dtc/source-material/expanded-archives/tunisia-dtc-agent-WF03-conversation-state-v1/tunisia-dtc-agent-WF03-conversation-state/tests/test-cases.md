# WF-03 tests

### STATE-01 first message
Expected stage NEW -> DISCOVERY for product_discovery.

### STATE-02 product question
Expected stage -> CONSIDERING.

### STATE-03 cart add
Expected stage -> CART_BUILDING.

### STATE-04 checkout start
Expected stage -> CHECKOUT_READY.

### STATE-05 safety/complaint
Expected stage -> HUMAN_ESCALATION.

### STATE-06 turn limit
turn_count becomes 16.
Expected HUMAN_ESCALATION.

### STATE-07 invalid transition
If a transition is not in the allowed map, retain current stage.

### STATE-08 language persistence
Latin Tounsi metadata remains script=latin.

### STATE-09 cart state
cart_id and selected_variant are preserved across turns.

### STATE-10 restart
A known conversation reloads state from the trusted state store.
