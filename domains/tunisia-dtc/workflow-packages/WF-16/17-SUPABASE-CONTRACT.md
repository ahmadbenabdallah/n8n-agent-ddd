# Supabase / Persistence Contract

WF-16 may persist rendering/delivery state through the orchestration persistence layer.

Suggested records:

## response_deliveries

- response_id
- conversation_id
- channel
- payload_hash
- delivery_status
- provider_message_id
- attempt_count
- created_at
- updated_at

## rendering_events

- event_id
- response_id
- conversation_id
- mode
- validation_status
- fallback_used
- source_fact_ids
- rendered_action_ids
- created_at

Apply least privilege and RLS. WF-16 should not receive broad database credentials.

Do not persist sensitive channel tokens or payment credentials.
