# Dependency Monitoring

Monitor:
- DNS/network connectivity;
- TLS/certificate validity;
- API authentication validity;
- rate limits;
- latency;
- HTTP error classes;
- response schema drift;
- service availability;
- dependency version changes.

## WooCommerce

Monitor:
- REST API;
- Store API where used;
- authentication;
- expected response schema;
- product/order access;
- timeout/error rate.

## OpenAI

Monitor:
- API availability;
- latency;
- rate-limit responses;
- structured-output failures;
- model/configuration version.

## Messenger

Monitor:
- webhook receipt;
- send success;
- provider errors;
- duplicate delivery behavior.

Credentials must never be included in health-check output.
