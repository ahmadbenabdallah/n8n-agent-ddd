# WF-17 — Audit & Analytics v1

Central audit/event boundary for the Tunisia DTC AI agent.

## Purpose

Capture security- and business-relevant events across:
- inbound gateway
- security gate
- identity
- state
- intent
- retrieval
- LLM reasoning
- action validation
- commerce services
- escalation
- rendering
- channel delivery

## Design rule

Audit useful metadata, not raw sensitive content.

Never persist:
- passwords
- OTP/CVV/PIN
- card/PAN data
- API keys/access tokens
- system/developer prompts
- raw customer messages unless a separate privacy-approved retention system exists
- raw retrieved chunks by default
- hidden security/fraud signals

The workflow creates a deterministic event fingerprint and optional previous-fingerprint chain field. For strong tamper evidence, use a database append-only policy/WORM storage or signed event service; the lightweight fingerprint here is not a cryptographic signature.

## Import
Import the workflow JSON into n8n and connect the persistence adapter to the audit database.
