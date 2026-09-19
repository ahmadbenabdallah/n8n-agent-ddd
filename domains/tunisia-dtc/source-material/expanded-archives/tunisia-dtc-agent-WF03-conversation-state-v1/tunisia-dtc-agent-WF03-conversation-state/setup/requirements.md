# Requirements

- WF-02 Identity output
- trusted conversation identifier
- Supabase or Redis for persistence
- `conversations` table
- state transition rules
- optional bounded conversation history source

The state store is trusted application data. Customer text cannot directly change authorization
or state permissions.
