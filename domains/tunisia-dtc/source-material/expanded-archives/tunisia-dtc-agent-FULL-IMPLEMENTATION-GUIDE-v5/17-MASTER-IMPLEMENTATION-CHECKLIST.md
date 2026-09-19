# Master Implementation Checklist

## Foundation
- [ ] DEV/STAGING/PROD separated
- [ ] n8n persistence configured
- [ ] n8n encryption key secured
- [ ] Supabase provisioned
- [ ] pgvector enabled
- [ ] WooCommerce staging store ready
- [ ] WooCommerce credentials stored securely
- [ ] OpenAI credentials stored securely
- [ ] Meta webhook configured
- [ ] backups configured

## Control plane
- [ ] WF-00 complete
- [ ] WF-01 complete
- [ ] WF-02 complete
- [ ] WF-03 complete
- [ ] WF-04 complete
- [ ] WF-08 complete
- [ ] WF-17 complete
- [ ] WF-19 complete

## Commerce
- [ ] WF-11 complete
- [ ] WF-12 complete
- [ ] WF-13 complete
- [ ] WF-14 complete
- [ ] WF-15 complete
- [ ] WF-07 complete
- [ ] WF-20 complete

## Intelligence
- [ ] WF-05 complete
- [ ] WF-06 complete
- [ ] WF-09 complete
- [ ] WF-10 complete

## Customer response
- [ ] WF-16 complete
- [ ] language/script validation tested
- [ ] privacy filtering tested
- [ ] unknown execution wording tested

## Knowledge
- [ ] WF-18 complete
- [ ] source provenance implemented
- [ ] quarantine implemented
- [ ] rollback tested
- [ ] dynamic/live separation enforced

## Security
- [ ] prompt injection tests pass
- [ ] identity abuse tests pass
- [ ] tool misuse tests pass
- [ ] excessive agency tests pass
- [ ] sensitive disclosure tests pass
- [ ] KB poisoning tests pass
- [ ] rate/consumption controls pass
- [ ] architecture boundary tests pass

## Commerce safety
- [ ] price comes from commerce
- [ ] stock comes from commerce
- [ ] promotion eligibility comes from live validation
- [ ] checkout totals are revalidated
- [ ] COD payment semantics are correct
- [ ] idempotency implemented
- [ ] unknown execution reconciliation implemented

## Operations
- [ ] audit events verified
- [ ] dashboards available
- [ ] alerts configured
- [ ] dead-letter/retry handling tested
- [ ] incident runbooks tested
- [ ] rollback tested
- [ ] recovery tested

## Release gate
- [ ] staging E2E pass
- [ ] red-team pass
- [ ] load test pass
- [ ] security review pass
- [ ] business owner acceptance
- [ ] production backup verified
- [ ] workflow versions frozen
