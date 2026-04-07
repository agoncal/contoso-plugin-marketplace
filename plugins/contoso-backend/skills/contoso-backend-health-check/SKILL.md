---
name: contoso-backend-health-check
description: Health, readiness, and liveness endpoint implementation following Contoso observability standards
---

## Health Check Skill

This skill provides patterns for implementing health check endpoints in Contoso backend services. Use this when setting up new services, configuring Kubernetes probes, or implementing dependency checks.

## Contoso Health Endpoint Standards

Every service must expose three health endpoints:

| Endpoint | Purpose | Used by | Response time |
|----------|---------|---------|---------------|
| `GET /health` | Overall service health summary | Monitoring dashboards | < 500ms |
| `GET /health/live` | Is the process alive and responsive? | Kubernetes liveness probe | < 100ms |
| `GET /health/ready` | Can the service handle traffic? | Kubernetes readiness probe, load balancers | < 500ms |

## Endpoint Specifications

### Liveness — `/health/live`

Checks only that the service process is running and can respond to HTTP requests. Must not check external dependencies.

```json
{
  "status": "UP",
  "timestamp": "2024-06-15T10:30:00Z"
}
```

Return `200 OK` if alive, `503 Service Unavailable` if not.

### Readiness — `/health/ready`

Checks that the service can accept and process requests. Verifies critical dependencies.

```json
{
  "status": "UP",
  "checks": {
    "database": { "status": "UP", "responseTime": "12ms" },
    "cache": { "status": "UP", "responseTime": "3ms" },
    "messageQueue": { "status": "UP", "responseTime": "8ms" }
  },
  "timestamp": "2024-06-15T10:30:00Z"
}
```

Return `200 OK` if all critical checks pass, `503 Service Unavailable` if any critical check fails.

### Full Health — `/health`

Comprehensive health summary including version info, uptime, and all dependency statuses.

```json
{
  "status": "UP",
  "service": {
    "name": "contoso-order-service",
    "version": "2.1.0",
    "environment": "production",
    "uptime": "3d 12h 45m"
  },
  "checks": {
    "database": { "status": "UP", "responseTime": "12ms", "type": "postgresql" },
    "cache": { "status": "UP", "responseTime": "3ms", "type": "redis" },
    "messageQueue": { "status": "UP", "responseTime": "8ms", "type": "rabbitmq" },
    "externalApi": { "status": "DEGRADED", "responseTime": "2100ms", "type": "http" }
  },
  "timestamp": "2024-06-15T10:30:00Z"
}
```

## Health Check Implementation Rules

1. **Liveness must be lightweight** — No database queries, no external calls. Only check if the process can respond.

2. **Readiness checks critical dependencies** — Database, cache, message queue. If any critical dependency is down, return 503 so the load balancer stops sending traffic.

3. **Use timeouts on dependency checks** — Each check should timeout after 5 seconds. A slow dependency check should not block the health response.

4. **Categorize dependencies**:
   - **Critical**: Service cannot function without it (database, auth service). Failure → 503.
   - **Non-critical**: Service can function in degraded mode (cache, analytics). Failure → 200 with `DEGRADED` status.

5. **Cache health results** — Cache readiness check results for 5 seconds to prevent thundering herd on health endpoints.

6. **No authentication required** — Health endpoints must be publicly accessible (they're called by infrastructure, not users).

7. **No sensitive information** — Never expose connection strings, credentials, or internal IPs in health responses.

## Kubernetes Probe Configuration

```yaml
livenessProbe:
  httpGet:
    path: /health/live
    port: 8080
  initialDelaySeconds: 15
  periodSeconds: 10
  timeoutSeconds: 3
  failureThreshold: 3

readinessProbe:
  httpGet:
    path: /health/ready
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 5
  timeoutSeconds: 5
  failureThreshold: 2

startupProbe:
  httpGet:
    path: /health/live
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
  failureThreshold: 30
```
