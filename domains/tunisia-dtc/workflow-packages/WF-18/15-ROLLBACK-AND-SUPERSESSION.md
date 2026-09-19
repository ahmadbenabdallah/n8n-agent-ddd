# Rollback & Supersession

Every published KB version must be identifiable.

Rollback:

```text
current published version
        |
        v
disable publication
        |
        v
restore previous approved version
        |
        v
invalidate affected retrieval cache
        |
        v
audit + notify operations
```

Never delete historical versions merely to hide an error.

Supersession records:
- old version;
- new version;
- reason;
- actor;
- timestamp;
- affected source/chunks.

If a poisoned source is discovered:
1. quarantine immediately;
2. remove it from production retrieval;
3. identify affected answers;
4. audit exposure;
5. restore known-good version;
6. investigate root cause.
