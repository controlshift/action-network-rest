# Changelog

## [2.0.0] - 2026-06-30

### Breaking Changes
- When a response has a 403 status, now raises AuthorizationError. (Previously, ResponseError was raised in this case.)

### Other Changes
- Added a new error class ServerError, as a subclass of ResponseError. 5xx response statuses now raise this more specific type of error.

## [1.1.0] - 2026-02-11

### Breaking Changes
- Now requires Faraday 2.x (previously supported Faraday 1.x)
- Dropped support for Ruby versions older than 3.3. Officially supported versions are Ruby 3.3, 3.4, and 4.0.
