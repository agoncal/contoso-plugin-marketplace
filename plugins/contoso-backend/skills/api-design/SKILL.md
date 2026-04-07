---
name: api-design
description: REST API design conventions, error formats, pagination patterns, versioning, and OpenAPI specification generation
---

## Contoso API Design Skill

This skill provides guidance on designing and implementing REST APIs that conform to Contoso's engineering standards. Use this skill when creating new endpoints, reviewing API designs, or generating OpenAPI specifications.

## URL Structure and Versioning

All APIs must follow the versioned URL pattern:

```
https://{service}.contoso.com/api/v{major}/{resource}
```

Resource naming rules:
- Use plural nouns for collections: `/api/v1/users`, `/api/v1/orders`
- Use singular nouns for singleton resources: `/api/v1/users/{id}/profile`
- Nest sub-resources to a maximum depth of 3: `/api/v1/users/{id}/orders/{orderId}/items`
- Use kebab-case for multi-word resource names: `/api/v1/order-items`
- Never use verbs in URLs — use HTTP methods to express actions

## Standard Error Response Format

Every error response must use the following structure:

```json
{
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "One or more fields failed validation.",
    "details": [
      {
        "field": "email",
        "reason": "Must be a valid email address."
      },
      {
        "field": "age",
        "reason": "Must be a positive integer."
      }
    ]
  }
}
```

Standard error codes (always UPPER_SNAKE_CASE):
- `VALIDATION_FAILED` — 400: request body or parameters failed validation
- `AUTHENTICATION_REQUIRED` — 401: missing or invalid credentials
- `PERMISSION_DENIED` — 403: valid credentials but insufficient permissions
- `RESOURCE_NOT_FOUND` — 404: the requested resource does not exist
- `RESOURCE_CONFLICT` — 409: action conflicts with current resource state
- `RATE_LIMIT_EXCEEDED` — 429: too many requests
- `INTERNAL_ERROR` — 500: unexpected server error (never include stack traces)

## Cursor-Based Pagination

Cursor-based pagination is the Contoso standard. Implement it as follows:

**Request:**
```
GET /api/v1/users?cursor=eyJpZCI6MTAwfQ&limit=25
```

**Response:**
```json
{
  "data": [ ... ],
  "pagination": {
    "nextCursor": "eyJpZCI6MTI1fQ",
    "previousCursor": "eyJpZCI6NzV9",
    "limit": 25,
    "totalCount": 1042
  }
}
```

Rules:
- Default `limit` is 25, maximum is 100.
- Cursors should be opaque, base64-encoded strings. Never expose raw database IDs.
- `totalCount` is optional and may be omitted for performance on large datasets.
- Always include `nextCursor: null` when on the last page.

## Filtering and Sorting

Filtering uses query parameters with intuitive naming:

```
GET /api/v1/orders?status=active&createdAfter=2024-01-01&customerId=abc-123
```

Sorting uses the `sort` parameter with field and direction:

```
GET /api/v1/orders?sort=createdAt:desc,total:asc
```

- Multiple sort fields are comma-separated.
- Default direction is `asc` if omitted.
- Return 400 if an unsupported sort field is requested.

## OpenAPI Specification Generation

Every API must have an OpenAPI 3.0 specification. Include:

```yaml
openapi: 3.0.3
info:
  title: Contoso {Service} API
  version: 1.0.0
  description: |
    API for managing {resources} within the Contoso platform.
  contact:
    name: Contoso Engineering
    email: engineering@contoso.com
servers:
  - url: https://{service}.contoso.com/api/v1
    description: Production
  - url: https://{service}.staging.contoso.com/api/v1
    description: Staging
```

Every endpoint definition must include:
- `summary` and `description`
- All parameters with descriptions and examples
- Request body schema with required fields marked
- Response schemas for success and all possible error codes
- At least one `example` per request/response schema

## HATEOAS Links

Resource responses must include navigational links:

```json
{
  "id": "usr-123",
  "name": "Jane Doe",
  "_links": {
    "self": { "href": "/api/v1/users/usr-123" },
    "orders": { "href": "/api/v1/users/usr-123/orders" },
    "profile": { "href": "/api/v1/users/usr-123/profile" }
  }
}
```

Collection responses include pagination links:

```json
{
  "data": [ ... ],
  "_links": {
    "self": { "href": "/api/v1/users?cursor=abc&limit=25" },
    "next": { "href": "/api/v1/users?cursor=def&limit=25" },
    "prev": { "href": "/api/v1/users?cursor=xyz&limit=25" }
  }
}
```
