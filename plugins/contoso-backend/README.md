# contoso-backend

General backend and API development — REST/GraphQL API design, microservice patterns, and Contoso API conventions.

## Components

| Type | Name | Description |
|------|------|-------------|
| Agent | `contoso-backend` | Backend and API development expert |
| Skill | `contoso-backend-api-design` | REST/GraphQL API design |
| Hook | PreToolCall on `create` | Enforces API versioning and error handling in route/controller files |

## Installation

```shell
copilot plugin install contoso-backend@contoso-marketplace
```

## What It Does

The **contoso-backend** agent enforces Contoso's API conventions:

- **URL structure**: `/api/v{version}/` with plural nouns, kebab-case, max 2 nesting levels
- **HTTP methods**: Proper usage with correct status codes (201+Location for POST, 204 for DELETE)
- **Error format**: `{ "error": { "code": "...", "message": "...", "details": [...] } }`
- **Pagination**: Cursor-based with `{ cursor, hasMore, limit }`
- **Health endpoints**: `/health`, `/health/ready`, `/health/live`
- **Security**: Bearer token auth, rate limiting (100/min authenticated, 20/min anonymous)
- **Architecture**: Layered (Controller → Service → Repository), 12-factor app methodology

> **See also**: [contoso-backend-java](../contoso-backend-java/), [contoso-backend-dotnet](../contoso-backend-dotnet/), [contoso-backend-python](../contoso-backend-python/), [contoso-backend-typescript](../contoso-backend-typescript/) for language-specific plugins.
