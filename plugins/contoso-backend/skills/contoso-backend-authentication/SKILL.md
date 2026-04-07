---
name: contoso-backend-authentication
description: JWT and OAuth2 authentication implementation patterns following Contoso security standards
---

## Authentication Skill

This skill provides patterns for implementing authentication and authorization in Contoso backend services. Use this when adding auth to new services, implementing token-based authentication, or integrating with OAuth2 providers.

## Contoso Authentication Standards

### Token Strategy

Contoso uses a dual-token strategy:

| Token | Type | Expiration | Storage | Purpose |
|-------|------|-----------|---------|---------|
| Access Token | JWT | 15 minutes | Memory only (never localStorage) | API authorization |
| Refresh Token | Opaque | 7 days | HttpOnly secure cookie | Obtain new access tokens |

### JWT Access Token Structure

```json
{
  "header": {
    "alg": "RS256",
    "typ": "JWT",
    "kid": "contoso-key-2024"
  },
  "payload": {
    "sub": "usr-abc-123",
    "email": "jane@contoso.com",
    "roles": ["user", "admin"],
    "permissions": ["read:users", "write:orders"],
    "iss": "https://auth.contoso.com",
    "aud": "https://api.contoso.com",
    "iat": 1718450000,
    "exp": 1718450900,
    "jti": "tok-unique-id"
  }
}
```

### Token Rules

1. **Use RS256** (asymmetric) for JWT signing — never HS256 in production.
2. **Rotate signing keys** quarterly. Support multiple `kid` values during rotation.
3. **Validate all claims**: `iss`, `aud`, `exp`, `nbf`. Reject tokens that fail any check.
4. **Include minimal claims** — Only include what's needed for authorization. Fetch additional user data from the user service.
5. **Never store sensitive data in JWTs** — No passwords, SSNs, or financial data.

## Authentication Flow

### Login Flow
```
1. Client → POST /api/v1/auth/login { email, password }
2. Server validates credentials (bcrypt compare, cost factor ≥ 12)
3. Server generates access token (JWT) + refresh token (opaque, stored in DB)
4. Server → 200 { accessToken } + Set-Cookie: refreshToken (HttpOnly, Secure, SameSite=Strict)
```

### Token Refresh Flow
```
1. Client detects 401 response
2. Client → POST /api/v1/auth/refresh (refresh token sent via cookie)
3. Server validates refresh token against DB
4. Server rotates refresh token (invalidate old, issue new)
5. Server → 200 { accessToken } + Set-Cookie: refreshToken (new)
```

### Logout Flow
```
1. Client → POST /api/v1/auth/logout
2. Server invalidates refresh token in DB
3. Server → 204 + Clear-Cookie: refreshToken
```

## Authorization Patterns

### Role-Based Access Control (RBAC)

```
Roles:
  - viewer:  read access to own resources
  - user:    read/write access to own resources
  - admin:   read/write access to all resources
  - superadmin: full system access
```

### Permission-Based Access Control

Use granular permissions for fine-grained access:
```
permissions: ["read:users", "write:users", "delete:users", "read:orders"]
```

### Middleware Pattern

Every protected endpoint must:
1. Extract the Bearer token from the Authorization header
2. Verify JWT signature and claims
3. Check required roles/permissions for the endpoint
4. Attach the authenticated user context to the request
5. Return 401 for missing/invalid tokens, 403 for insufficient permissions

## Password Security

- Hash with **bcrypt** (cost factor ≥ 12) or **argon2id**
- Enforce minimum password requirements: 12+ characters, mix of upper/lower/digits/symbols
- Implement account lockout after 5 failed attempts (15-minute cooldown)
- Never log passwords, even in debug mode
- Use constant-time comparison for password/token validation

## OAuth2 Integration

When integrating with external OAuth2 providers (Microsoft Entra ID, Google):
- Use Authorization Code flow with PKCE (never Implicit flow)
- Validate `state` parameter to prevent CSRF
- Exchange authorization code for tokens server-side
- Map external identity to internal Contoso user record
- Store provider tokens encrypted in the database
