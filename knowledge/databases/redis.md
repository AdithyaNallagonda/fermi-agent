# Redis / Valkey (ElastiCache, MemoryDB, Azure Managed Redis, Memorystore)
Last reviewed: 2026-10 ⚠️ licensing & managed offerings changed 2024–2025 — verify

## Licensing landscape
Redis moved from BSD to RSALv2/SSPLv1 (Mar 2024) → Linux Foundation fork **Valkey** (BSD). Redis 8
(2025) added AGPLv3 as an option. AWS ElastiCache/MemoryDB and Google Memorystore offer Valkey (often
cheaper than Redis OSS engine on AWS ⚠️ verify). **Azure Cache for Redis is retiring** (verified on Microsoft
Learn, 2026-10): new customers blocked from 1 Apr 2026; Enterprise/Enterprise Flash retire **31 Mar 2027**;
Basic/Standard/Premium retire **30 Sep 2028** (tenants with caches before 1 Apr 2026 may keep creating them until
then). Target: **Azure Managed Redis** (Redis Enterprise software, zone-redundant by default, Entra ID auth, active
geo-replication, modules; migration tooling GA for Enterprise, preview for B/S/P).

## Mental model
In-memory data structure server; single-threaded command execution per shard (I/O threads in newer
versions) → operations are atomic; sub-millisecond latency; persistence optional (RDB snapshots, AOF).

## Data structures → use cases
| Structure | Use |
|---|---|
| String | Cache values, counters (`INCR`), distributed locks (`SET k v NX PX`) |
| Hash | Objects/sessions |
| List | Simple queues (prefer Streams) |
| Set | Unique members, tags |
| Sorted set | Leaderboards, priority queues, sliding-window rate limits, time-indexed items |
| Stream | Event log with consumer groups (lightweight Kafka-like) |
| Bitmap / Bitfield | Feature flags, daily active users |
| HyperLogLog | Approx. unique counts (~0.81% error, 12 KB) |
| Geo | Proximity search |
| JSON / Search / Vector (Redis Stack / Redis 8 / MemoryDB / Valkey modules ⚠️) | Document queries, vector similarity, semantic cache |
| Pub/Sub | Fire-and-forget fan-out (no persistence) |

## Deployment modes
- Standalone + replicas with Sentinel (auto-failover) — non-clustered.
- **Cluster mode**: 16,384 hash slots across shards; multi-key ops must hit the same slot (use hash
  tags `{user:1}:cart`); clients must be cluster-aware.
- Managed: ElastiCache (node-based or **Serverless**), **MemoryDB** (durable, multi-AZ transaction log →
  can be a primary database), Azure Managed Redis, Memorystore for Redis Cluster/Valkey.

## Patterns
Cache-aside, session store, rate limiting (Lua scripts or `INCR`+`EXPIRE`), distributed locks (single-
instance `SET NX PX` + fencing; Redlock debated), leaderboards (ZSET), queues (Streams with consumer
groups, XACK, pending entries), pub/sub fan-out, semantic caching for LLMs (vector similarity),
idempotency key store, feature flags.

## Eviction & memory
`maxmemory-policy`: `allkeys-lru` / `allkeys-lfu` (caches), `volatile-*` (only keys with TTL),
`noeviction` (data store — writes fail when full). Monitor `used_memory`, fragmentation ratio,
evictions, hit ratio. Reserve memory for replication/snapshots (fork copy-on-write) — e.g., ElastiCache
`reserved-memory-percent` default 25%.

## Performance gotchas
`KEYS *` (use `SCAN`), big keys (> 1 MB values or huge collections → latency spikes; `--bigkeys`),
hot keys (shard imbalance → client-side caching / replicas / key splitting), long Lua scripts block,
O(N) commands on huge sets, too many connections (use pooling), cross-AZ latency.

## Security
TLS in transit, AUTH/ACLs (RBAC users), IAM auth (ElastiCache/MemoryDB), private subnets only, encryption
at rest, disable dangerous commands.

## Interview angles
Implement rate limiter, leaderboard, session store; cache stampede protection; Redis vs Memcached
(data structures, persistence, replication vs multithreaded simplicity); is Redis a database? (MemoryDB
yes; ElastiCache = cache with possible data loss on failover).

## Enterprise architect lens
- **Engine strategy**: standardize on **Valkey** for new AWS/GCP caches (open-source BSD, lower managed price ⚠️),
  Azure Managed Redis on Azure (migrate off Azure Cache for Redis before 2027/2028 retirements), Redis
  Enterprise/Cloud only where active-active CRDT geo-replication or Redis-specific modules are required.
- **Classification rule**: cache = disposable (no source-of-truth data, TTLs mandatory); MemoryDB/durable Redis
  only with explicit approval as a primary store.
- **Platform offering**: golden module (cluster mode, TLS, AUTH/IAM, multi-AZ, alarms on evictions/memory/
  latency), per-team logical isolation via ACL users/key prefixes or separate clusters for noisy workloads.
- **AI patterns**: semantic cache in front of LLM gateways (tenant- and ACL-aware keys), session/agent short-term
  memory, rate-limit counters for token budgets.
