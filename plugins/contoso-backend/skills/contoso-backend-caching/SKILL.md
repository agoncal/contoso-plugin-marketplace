---
name: contoso-backend-caching
description: Redis and in-memory caching strategies with Contoso cache patterns and invalidation rules
---

## Caching Skill

This skill provides patterns for implementing caching in Contoso backend services. Use this when adding caching to existing services, choosing a caching strategy, or configuring cache invalidation.

## Contoso Caching Standards

### When to Cache

| Scenario | Cache? | Strategy |
|----------|--------|----------|
| Frequently read, rarely changed data (config, feature flags) | ✅ | Long TTL (1 hour+), event-based invalidation |
| User session data | ✅ | Short TTL (15 min), refresh on activity |
| API responses for GET endpoints | ✅ | Medium TTL (5 min), vary by query params |
| Write-heavy data (real-time counters) | ⚠️ | Write-behind with short TTL |
| Transactional data (payments, orders) | ❌ | Never cache — always read from source |

### Cache Layers

```
Client → CDN (static assets) → API Gateway (response cache) → Application (L1 in-memory) → Redis (L2 distributed) → Database
```

## Caching Patterns

### Cache-Aside (Lazy Loading) — Contoso Default

```
Read:
  1. Check cache for key
  2. If hit → return cached value
  3. If miss → query database, store in cache, return value

Write:
  1. Update database
  2. Invalidate cache key (delete, don't update)
```

This is the Contoso default pattern. Use it unless you have a specific reason for another strategy.

### Write-Through

```
Write:
  1. Write to cache
  2. Cache writes to database synchronously
  3. Return success

Read:
  1. Always read from cache (guaranteed fresh)
```

Use for data that must be immediately consistent after writes.

### Write-Behind (Write-Back)

```
Write:
  1. Write to cache
  2. Return success immediately
  3. Cache flushes to database asynchronously (batch)
```

Use for high-write-throughput scenarios where eventual consistency is acceptable (analytics, counters).

## Cache Key Convention

```
{service}:{entity}:{identifier}:{variant}
```

Examples:
- `order-svc:user:usr-123:profile`
- `order-svc:orders:usr-123:page-1`
- `catalog-svc:product:prod-456:details`
- `auth-svc:permissions:usr-123:roles`

Rules:
- Use colons as separators
- Include the service name to prevent cross-service collisions
- Keep keys under 256 characters
- Never include sensitive data in keys

## TTL Guidelines

| Data type | TTL | Justification |
|-----------|-----|---------------|
| Static configuration | 1 hour | Rarely changes, low staleness risk |
| User profile | 15 minutes | Moderate change frequency |
| Search results | 5 minutes | Freshness matters, frequent updates |
| Session data | 30 minutes | Security: limit stale session window |
| Feature flags | 5 minutes | Need relatively quick propagation |
| Rate limit counters | Matches the rate limit window | Must be accurate per window |

## Cache Invalidation Rules

1. **Invalidate on write** — Always delete the cache key when the underlying data changes. Never try to update the cached value.

2. **Use TTL as a safety net** — Even with explicit invalidation, always set a TTL. This prevents stale data if invalidation fails.

3. **Invalidate related keys** — When a user is updated, invalidate `user:profile`, `user:permissions`, and any aggregations that include the user.

4. **Event-driven invalidation** — For distributed systems, publish cache invalidation events via the message queue so all service instances invalidate their local caches.

5. **Never cache `null` without a short TTL** — If you cache a "not found" result to prevent cache stampede, use a very short TTL (30 seconds).

## Redis Configuration (Contoso Standard)

```yaml
redis:
  host: ${REDIS_HOST}
  port: 6379
  password: ${REDIS_PASSWORD}
  ssl: true
  database: 0
  pool:
    max-active: 20
    max-idle: 10
    min-idle: 5
    max-wait: 2000ms
  timeout: 1000ms
```

## Cache Monitoring

Track these metrics:
- **Hit rate**: Target > 90% for hot data. Investigate if below 80%.
- **Miss rate**: High miss rate indicates poor key design or insufficient TTL.
- **Eviction rate**: High evictions indicate the cache is too small.
- **Latency**: Redis get/set should be < 5ms. Investigate if > 10ms.
- **Memory usage**: Set `maxmemory` with `allkeys-lru` eviction policy.

## Graceful Degradation

If the cache is unavailable:
- Fall back to the database — never fail the request because the cache is down.
- Log a WARN-level alert so the team is notified.
- Implement a circuit breaker to stop hammering the unhealthy cache.
- Retry cache connections with exponential backoff.
