# Azure Cosmos DB
Last reviewed: 2026-10 ⚠️ verify via `microsoft-learn` MCP

## Mental model
Globally distributed, multi-model database with SLAs on latency (< 10 ms reads/writes at p99 for point
operations), throughput, consistency, and availability. Container data is partitioned by a **partition
key**; throughput is measured in **Request Units (RU/s)**.

## APIs
NoSQL (native, richest features), MongoDB (RU-based) and **Azure DocumentDB / Cosmos DB for MongoDB
vCore** (vCore-based, MongoDB-compatible ⚠️ naming), Cassandra, Gremlin (graph), Table, PostgreSQL (Citus
distributed Postgres). Choose NoSQL API for greenfield unless you need wire compatibility.

## Key limits (⚠️ verify)
- Item max **2 MB**. Logical partition (all items with same PK value) max **20 GB** (hierarchical
  partition keys — up to 3 levels — lift this by sub-partitioning).
- Physical partition: up to 10,000 RU/s and 50 GB; system splits automatically.
- 1 RU ≈ point read of a 1 KB item; writes ~5+ RU; queries vary with index/complexity.

## Throughput models
Provisioned (manual), **autoscale** (scales between 10% and 100% of max RU/s), serverless (pay per RU,
for dev/low traffic), database-level shared throughput. Burst capacity, priority-based execution,
throughput redistribution across partitions ⚠️.

## Consistency levels (strong → weak)
**Strong** → **Bounded staleness** → **Session** (default; read-your-writes per session token) →
**Consistent prefix** → **Eventual**. Strong with multi-region writes is not supported; strong across
regions adds write latency. Reads at weaker levels cost fewer RUs.

## Global distribution
Add regions with a click; single-write-region with automatic failover, or **multi-region writes** with
conflict resolution (LWW on `_ts` or custom path, or custom stored procedure). Per-region RU billing.

## Modeling tips
- Partition key: high cardinality, evenly distributed, used in most queries (avoid cross-partition
  fan-out queries). Synthetic keys (`tenantId-userId`) or hierarchical keys for multi-tenant.
- Embed data read together; reference when unbounded or independently updated.
- Indexing policy: default indexes everything — exclude unused paths to cut write RU; composite indexes
  for ORDER BY on multiple fields.
- Change feed (all versions & deletes mode, latest version mode) for CDC: materialized views, search
  indexing, event-driven processing.
- Vector search in NoSQL API (DiskANN, quantizedFlat, flat), full-text and hybrid search ⚠️ verify GA.

## Cost levers
Right-size RU with autoscale; reserved capacity; TTL; index exclusion; point reads (id + PK) are
cheapest; avoid cross-partition queries; analytical store + Synapse Link / Fabric mirroring for analytics.

## Gotchas
Hot logical partitions → 429 throttling (handle with SDK retries + backoff); 20 GB logical partition cap;
cross-partition queries cost; changing partition key needs migration (container copy jobs).

## Interview angles
Consistency levels trade-offs; partition key selection for multi-tenant SaaS; Cosmos DB vs DynamoDB
(similar model; Cosmos offers 5 consistency levels and multiple APIs; DynamoDB simpler pricing, deeper
AWS integration).
