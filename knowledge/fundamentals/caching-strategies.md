# Caching Strategies
Last reviewed: 2026-10 | Load when: performance, read scaling, CDN, cache invalidation
(Redis engine specifics → `databases/redis.md`)

## Cache layers (outer → inner)
Browser (Cache-Control, ETag) → CDN/edge (CloudFront/Front Door/Cloud CDN) → API gateway cache →
application in-process (LRU; e.g., Caffeine, MemoryCache) → distributed cache (Redis/Valkey/Memcached)
→ DB buffer pool / result caches.

## Patterns
| Pattern | Write path | Read path | Use when | Risk |
|---|---|---|---|---|
| Cache-aside (lazy) | App writes DB, invalidates/deletes key | Miss → load DB → set | Default; read-heavy | Stale on races; first-hit latency |
| Read-through | Cache library loads on miss | Transparent | Simplify app code | Provider coupling |
| Write-through | Write cache + DB synchronously | Always warm | Read-after-write consistency | Write latency; caches unread data |
| Write-behind (back) | Write cache, async flush to DB | Fast | Write-heavy, tolerate loss risk | Data loss on cache failure |
| Refresh-ahead | Proactive refresh before TTL | Low latency | Predictable hot keys | Wasted refreshes |

## Invalidation (the hard part)
- TTL everywhere (+ jitter to avoid synchronized expiry).
- **Delete on write** rather than update-on-write (avoids racing stale writes); or versioned keys.
- Event-driven invalidation via CDC (DynamoDB Streams/Debezium → invalidate).
- Race: read-miss loads old value after a write deletes → use short TTL, "delayed double delete", or
  lease/version tokens (Facebook's memcache leases).

## Failure modes
- **Stampede / thundering herd**: many misses on hot key → single-flight/request coalescing, locks,
  probabilistic early expiration (XFetch), stale-while-revalidate.
- **Penetration**: queries for non-existent keys → cache negative results (short TTL), Bloom filter.
- **Avalanche**: mass expiry or cache cluster loss → TTL jitter, multi-AZ replicas, circuit breaker to DB,
  warm-up.
- **Hot key**: single shard overloaded → local in-process cache layer, key replication (key#1..N),
  read replicas.
- **Big keys**: > ~1 MB values block Redis → split, compress.

## Sizing
Working set × (1 + overhead ~30–50% for Redis metadata/fragmentation). Target hit ratio > 90% for
read-heavy APIs; monitor evictions and hit ratio.

## CDN essentials
Cache keys (normalize query strings/headers), TTL by content type, immutable hashed assets
(`Cache-Control: public, max-age=31536000, immutable`), `stale-while-revalidate`, origin shield,
signed URLs/cookies for private content, invalidation costs/latency, edge compute (CloudFront
Functions/Lambda@Edge, Cloudflare Workers) for auth/AB tests/redirects.

## Interview angles
"Where would you cache?" → identify hot read paths, tolerance for staleness, invalidation trigger,
TTL, size, and what happens when the cache dies.
