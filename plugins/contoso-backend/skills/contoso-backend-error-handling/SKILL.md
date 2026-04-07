---
name: contoso-backend-error-handling
description: Standardized error handling patterns with Contoso error response format and exception hierarchy
---

## Error Handling Skill

This skill provides patterns for implementing consistent error handling across Contoso backend services. Use this when creating new services, adding error handling to existing endpoints, or standardizing error responses.

## Contoso Exception Hierarchy

Every service must define a custom exception hierarchy:

```
ContosoBaseException (abstract)
├── ContosoValidationException        → 400 Bad Request
├── ContosoAuthenticationException    → 401 Unauthorized
├── ContosoForbiddenException         → 403 Forbidden
├── ContosoNotFoundException          → 404 Not Found
├── ContosoConflictException          → 409 Conflict
├── ContosoRateLimitException         → 429 Too Many Requests
└── ContosoInternalException          → 500 Internal Server Error
```

Each exception must include:
- An error code (UPPER_SNAKE_CASE string, e.g., `RESOURCE_NOT_FOUND`)
- A human-readable message
- Optional details array with field-level error information

## Standard Error Response Format

All error responses must conform to this structure:

```json
{
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "One or more fields failed validation.",
    "details": [
      {
        "field": "email",
        "reason": "Must be a valid email address."
      }
    ]
  },
  "meta": {
    "requestId": "req-abc-123",
    "timestamp": "2024-06-15T10:30:00Z"
  }
}
```

## Error Handling Rules

1. **Never expose internal details** — Stack traces, database errors, and implementation details must never appear in error responses. Log them server-side at ERROR level.

2. **Always include a request ID** — Every response (success and error) must include a `requestId` in the meta object for traceability.

3. **Use specific error codes** — Prefer `USER_EMAIL_ALREADY_EXISTS` over generic `VALIDATION_FAILED` when the error has a single, clear cause.

4. **Validate early, fail fast** — Validate all input at the API boundary before processing. Return all validation errors at once, not one at a time.

5. **Log contextually** — Log errors with correlation ID, user ID (if authenticated), request path, and relevant business context. Never log passwords, tokens, or PII.

6. **Handle downstream failures** — Wrap external service calls (APIs, databases, message queues) in try/catch blocks. Map external errors to appropriate Contoso error codes.

7. **Retry transient failures** — Use exponential backoff with jitter for retryable errors (network timeouts, 503 responses). Max 3 retries.

## Global Error Handler Pattern

Implement a centralized error handler that catches all exceptions and maps them to the standard response format. This should be the single point where exceptions are translated to HTTP responses.

## Error Logging Guidelines

| Severity | When to use | Example |
|----------|------------|---------|
| ERROR | Unexpected failures, data corruption, unhandled exceptions | Database connection lost, null pointer in business logic |
| WARN | Expected but noteworthy failures, degraded functionality | Rate limit hit, cache miss fallback, retry attempt |
| INFO | Business events that succeeded | User created, order placed, payment processed |
| DEBUG | Detailed flow information for troubleshooting | Request payload, query parameters, intermediate values |
