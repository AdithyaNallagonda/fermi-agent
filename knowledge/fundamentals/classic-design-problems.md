# Classic System Design Problems — Cheat Sheet
Last reviewed: 2026-10 | Load when: interview prep, mock interviews

Each entry: **core challenge → key design moves → deep-dive topics.**

1. **URL shortener** — read-heavy (100:1). ID generation (base62 of counter via ranges / Snowflake IDs /
   hash + collision check), KV store (DynamoDB/Cassandra), cache + CDN 301 vs 302 (analytics), custom
   aliases, expiry. Deep dive: ID uniqueness without coordination, analytics pipeline.
2. **Rate limiter** — token bucket / sliding window in Redis with Lua; per key tiers; distributed
   accuracy vs latency; fail-open vs fail-closed.
3. **News feed / timeline (Twitter/Instagram)** — fan-out on write (push to follower timelines in Redis)
   vs on read (pull) → hybrid: push for normal users, pull for celebrities. Ranking service, media via
   CDN, pagination by cursor.
4. **Chat (WhatsApp/Slack)** — WebSocket gateways (connection registry in Redis), message store
   partitioned by conversation (Cassandra/DynamoDB), per-conversation ordering (sequence numbers),
   delivery receipts, offline push (APNs/FCM), E2E encryption (Signal protocol), group fan-out.
5. **Notification system** — multi-channel (push/SMS/email), priority queues, templates, user
   preferences, rate limiting per user, retries + DLQ, idempotency, provider failover.
6. **Web crawler** — URL frontier (priority + politeness queues per host), DNS cache, robots.txt, dedup
   (Bloom filter + content hash/SimHash), distributed workers, storage in object store.
7. **Typeahead / autocomplete** — trie or prefix index with top-k precomputed per prefix, cached at
   edge; offline aggregation of query logs; personalization layer; < 100 ms.
8. **Ride-hailing (Uber)** — location updates (every ~4 s) to in-memory geo index (geohash/H3/quadtree,
   Redis GEO), matching service, trip state machine, surge pricing (stream processing), ETA service.
9. **Video streaming (YouTube/Netflix)** — upload → chunked transcoding pipeline (DAG of jobs) →
   ABR (HLS/DASH) renditions → CDN (Open Connect-style edge caches); metadata DB; recommendations.
10. **Distributed cache** — consistent hashing, replication, eviction (LRU/LFU), hot keys, cluster
    membership.
11. **Key-value store (Dynamo)** — consistent hashing + vnodes, replication N, quorum R/W, vector
    clocks/LWW, hinted handoff, Merkle anti-entropy, gossip.
12. **Unique ID generator** — Snowflake (timestamp 41b + machine 10b + seq 12b), UUIDv7 (time-ordered,
    index-friendly), DB ranges.
13. **Payment system** — idempotency keys, double-entry ledger (immutable), state machine, PSP
    integration with webhooks + reconciliation jobs, exactly-once-ish via dedup, PCI scope reduction
    (tokenization), outbox + saga.
14. **Ticketing / flash sale (BookMyShow/IRCTC Tatkal)** — inventory contention: Redis atomic
    decrement or DB row lock with short hold TTL (seat reservation), virtual waiting room/queue, rate
    limiting, idempotent checkout, eventual payment confirmation with timeout release.
15. **Proximity / Yelp** — geohash/quadtree index, read-heavy, cache by region; separate business
    write path.
16. **Google Docs (collaborative editing)** — OT or CRDTs, WebSocket sessions per doc, operation log,
    snapshots, presence.
17. **Distributed job scheduler / cron** — partitioned time-bucketed tables, leader/lease per
    partition, at-least-once execution + idempotent jobs, retries, DLQ.
18. **Metrics/monitoring system** — time-series DB (write-optimized, downsampling, retention tiers),
    pull vs push, alerting engine, cardinality control.
19. **Search engine for e-commerce** — OpenSearch with CDC indexing from catalog DB, analyzers,
    facets/aggregations, relevance tuning (BM25 + business boosts), hybrid semantic search, autocomplete.
20. **Dropbox/Google Drive** — chunking (4 MB) + content hashing for dedup, delta sync, metadata DB,
    block storage in S3, notification service for sync, conflict resolution.
21. **LLM chat assistant (ChatGPT-like) / RAG over enterprise docs** — streaming via SSE, conversation
    store, token rate limits, GPU inference pool or managed API, RAG pipeline with ACL-aware retrieval,
    semantic cache, guardrails, evals. See `ai/rag-architecture.md`.
22. **Leaderboard** — Redis sorted sets (ZADD/ZREVRANGE), sharding by score range for huge sets, periodic
    snapshots.

## 45-minute structure
5 min requirements → 5 estimates → 5 API/data model → 10 HLD → 15 deep dives → 5 bottlenecks/evolution.
