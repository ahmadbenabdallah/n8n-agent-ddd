# Source Registration Contract

Every source should have:

- `source_id`
- `source_uri` or controlled storage reference
- `source_type`
- `owner`
- `trust_class`
- `language`
- `version`
- `effective_from`
- `effective_until`
- `status`
- `checksum`
- `ingestion_run_id`
- `approval_reference`
- `created_at`
- `updated_at`

## Trust classes

`OFFICIAL_APPROVED`
- owned/approved business source.

`CONTROLLED_INTERNAL`
- approved internal operating material.

`EXTERNAL_REFERENCE`
- external material explicitly approved for reference.

`UNTRUSTED`
- customer content, arbitrary webpages, unknown uploads.

Untrusted sources cannot enter the production KB without a documented validation/approval process.
