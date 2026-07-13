## [1.4.0] - 2026-07-13
- Raise `MyTankInfo::ServiceUnavailableError` (subclass of `MyTankInfo::Error`) on HTTP 502/503/504 instead of `UnexpectedResponseError`, so callers can treat gateway-level outages as transient (retry/discard) rather than unexpected. `#status` exposes the HTTP status code

## [1.3.0] - 2026-07-10
- Raise `MyTankInfo::RateLimitError` (subclass of `MyTankInfo::Error`, so existing rescues keep working) on HTTP 429 instead of the generic `Error`, letting callers distinguish rate limiting from malformed requests and `retry_on` it in ActiveJob
- Expose `RateLimitError#retry_after` - the response's `Retry-After` header normalized to seconds (supports both delay-seconds and HTTP-date forms), or nil when absent

## [1.2.0] - 2026-06-02
- Raise `MyTankInfo::UnexpectedResponseError` (capturing the HTTP status and a truncated response body) when the API returns an unexpected status code or a non-JSON body, instead of letting the raw string flow downstream and surface as an opaque `NoMethodError`

## [1.1.1] - 2021-10-18
- Fix bug in NotificationContact delete logic

## [1.1.0] - 2021-09-23
- Added a specific error class ``MyTankInfo::UnauthorizedError`` so that it's easier to identify and react to scenarios when your api_key is wrong or has expired

## [1.0.2] - 2021-09-21
- Add convenience methods for accessing UOM on TankReconciliationRecordCollection
- Fix bug that prevented tank reconciliation records from being updated

## [1.0.1] - 2021-09-20
- Updates Faraday gem to 1.8.0
- Fixes Gemfile lock version of the gem

## [1.0.0] - 2021-09-20
- Initial release
