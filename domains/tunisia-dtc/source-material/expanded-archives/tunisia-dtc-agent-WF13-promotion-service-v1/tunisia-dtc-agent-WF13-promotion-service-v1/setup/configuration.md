# Configuration

## Suggested environment
- `PROMOTION_API_BASE_URL`
- `PROMOTION_API_TIMEOUT_MS=5000`
- `PROMOTION_MAX_DISCOUNT_TND` — optional business-policy ceiling

## Source priority
1. verified live promotion service
2. approved promotion policy
3. KB promotion documentation for explanatory/static information
4. never customer claims or LLM claims

## Currency
The example defaults to TND only as a schema fallback. The commerce source must provide the authoritative currency.

## Dates
Use server-side current time from the trusted execution environment. Do not accept a customer-provided date as the current date.
