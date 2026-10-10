# Distributed SQL / NewSQL
Last reviewed: 2026-10 ⚠️ fast-moving

## Why
Need SQL + ACID + horizontal write scaling + multi-region resilience without app-level sharding.

## Options
| System | Architecture | Consistency | Notes |
|---|---|---|---|
| Google Spanner | Paxos groups per split, TrueTime | External consistency (strict serializability) | 99.999% multi-region SLA; GoogleSQL & PostgreSQL dialects; graph, full-text, vector |
| Amazon Aurora DSQL (GA May 2025) | Serverless, active-active multi-Region (2 Regions + witness), optimistic concurrency (OCC) — no locks, conflicts detected at commit | Strong; snapshot isolation (≈ PG Repeatable Read, not selectable) | PostgreSQL-compatible dialect; IAM token auth; bounded transaction sizes; `SELECT … FOR UPDATE` doesn't block → contested rows surface as **SQLSTATE 40001** retries; read-only txns conflict-free; **foreign keys supported since Aug 2026** (extra reads per DML — benchmark); extended statistics; async DDL (one DDL per txn); ORM adapters (Drizzle etc.). Design for low contention + idempotent retryable transactions |
| CockroachDB | Raft ranges, HLC | Serializable default | Postgres wire-compatible; geo-partitioning; licensing changed (enterprise license required beyond free tier ⚠️) |
| YugabyteDB | DocDB (Raft) + PostgreSQL query layer reuse | Snapshot/serializable | High PG compatibility; Apache 2.0 core |
| TiDB | TiKV (Raft) + TiFlash columnar | Snapshot isolation | MySQL-compatible, HTAP |
| Citus (Postgres extension) | Sharded Postgres coordinator/workers | Per-shard ACID, distributed tx | Azure Cosmos DB for PostgreSQL / Elastic clusters |
| Aurora PostgreSQL Limitless Database (GA) | DB shard group = routers + shards; hash sharding on shard key | Single-database semantics via routers | Table types: **sharded** (by shard key; collocate tables sharing a key for single-shard joins), **reference** (full copy on every shard — small, rarely-updated lookups), **standard** (single shard; convertible). Scales writes/storage beyond one Aurora writer |
| Vitess / PlanetScale | Sharded MySQL | | YouTube heritage |

## Design considerations
- Primary key design to avoid hotspots (no monotonically increasing keys on range-partitioned systems —
  use hash-sharded indexes or UUIDs).
- Multi-region latency: writes need quorum across regions (cross-region RTT per commit) unless
  data is pinned to a home region (geo-partitioning / regional tables).
- Optimistic concurrency → retries on conflicts; keep transactions short.
- Compatibility gaps with PostgreSQL/MySQL (extensions, triggers, sequences semantics).

## When not to use
Single-region apps that fit on one Postgres primary (most apps!). Analytics workloads. Teams without
ops maturity for self-managed distributed systems.

## Interview angles
"Global bank ledger with strong consistency across regions" → Spanner/Aurora DSQL/CockroachDB; explain
commit latency cost and how TrueTime/HLC ordering works at a high level.
