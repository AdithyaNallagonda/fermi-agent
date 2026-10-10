# PostgreSQL (and managed variants)
Last reviewed: 2026-10 — PostgreSQL **18** is the latest major (18.6, Aug 2026); PG 19 expected ~Sep/Oct 2026 ⚠️;
PG 13 is EOL (Nov 2025). Verify managed-service version support (RDS/Aurora/Azure/Cloud SQL/AlloyDB).

## Mental model
Process-per-connection, MVCC (each update writes a new tuple version; VACUUM reclaims), WAL for
durability & replication, cost-based planner, extensible (extensions, custom types, index types).

## Core features worth knowing
- Index types: B-tree (default), Hash, GIN (JSONB, arrays, full-text), GiST (geo, ranges), SP-GiST,
  BRIN (huge append-only tables, time-ordered), partial & expression indexes, covering (`INCLUDE`).
- JSONB with GIN; full-text search (`tsvector`); PostGIS; **pgvector** (HNSW/IVFFlat); partitioning
  (declarative range/list/hash); logical replication; CTEs, window functions; row-level security (RLS).
- Isolation: Read Committed default; Repeatable Read (snapshot); Serializable (SSI).
- PG 17: incremental backups, improved vacuum memory; PG 18: async I/O subsystem, `uuidv7()`, virtual
  generated columns, skip-scan for B-tree ⚠️ verify details.

## Performance levers
1. Right indexes (check `EXPLAIN (ANALYZE, BUFFERS)`); avoid functions on indexed columns; composite
   index column order = equality first, then range.
2. **Connection pooling** (PgBouncer transaction mode, RDS Proxy, Azure built-in PgBouncer) — each
   connection costs ~5–10 MB; thousands of connections hurt.
3. Memory: `shared_buffers` ~25% RAM, `effective_cache_size` ~50–75%, `work_mem` per sort/hash op
   (careful: per operation × connections).
4. Autovacuum tuning for high-churn tables (scale factor, cost limits); watch bloat & transaction ID
   wraparound.
5. Partition large time-series tables; drop partitions instead of DELETE.
6. Read replicas for read scaling (async; replica lag).
7. Keyset pagination; batch writes; `COPY` for bulk load.

## Managed options
| Option | Highlights |
|---|---|
| Amazon RDS for PostgreSQL | Multi-AZ (instance or cluster with 2 readable standbys), read replicas |
| Aurora PostgreSQL | Shared distributed storage (6 copies across 3 AZs), up to 15 replicas, fast failover, Global Database, Serverless v2, I/O-Optimized pricing, Limitless Database (sharding) |
| Azure Database for PostgreSQL Flexible Server | Zone-redundant HA, built-in PgBouncer, Elastic clusters (Citus) |
| Google Cloud SQL / AlloyDB | AlloyDB: columnar engine for analytics, fast failover, AI integrations |
| Neon / Supabase / Crunchy | Serverless branching (Neon), BaaS (Supabase) — great for startups |

## Scaling beyond one primary
Vertical → read replicas → partitioning → functional split by service → sharding (Citus, Aurora
Limitless, app-level) → distributed SQL (see `newsql-distributed-sql.md`).

## Security
SCRAM auth, IAM auth (RDS/Azure Entra/Cloud SQL IAM), TLS required, RLS for multi-tenant, pgAudit,
encryption at rest via KMS, least-privilege roles, no superuser for apps.

## Gotchas
Long-running transactions block vacuum (bloat); `SELECT COUNT(*)` is slow on big tables; UUIDv4 primary
keys fragment B-trees (prefer UUIDv7/bigint identity); ORMs generating N+1 queries; `OFFSET` pagination;
lock-heavy migrations (`CREATE INDEX CONCURRENTLY`, add columns with defaults carefully on old versions).

## Interview angles
MVCC & vacuum; replica lag & read-your-writes; why pooling; multi-tenant (schema-per-tenant vs shared
table with tenant_id + RLS); pgvector vs dedicated vector DB.

## Enterprise architect lens
- **Fleet standards**: approved major versions + upgrade cadence (blue/green deployments on RDS/Aurora), extension
  allow-list (pgvector, PostGIS, pg_stat_statements, pgAudit), parameter group baselines, mandatory IAM auth +
  TLS, backup/PITR policy, tagging, CMK per data classification.
- **Self-service**: golden IaC module (multi-AZ, encryption, monitoring, Performance Insights/Database Insights,
  proxy) via the platform portal; DB-per-service by default.
- **Scale path**: vertical → read replicas → partitioning → Aurora Limitless/Citus sharding → DSQL/Spanner for
  multi-Region active-active; document the decision triggers (write TPS, storage, RPO/RTO).
- **Migration factory** (Oracle/SQL Server → Postgres): assessment scoring, SCT/DMS Schema Conversion (incl.
  generative-AI conversion assist ⚠️), CDC cutover, performance baselining, wave planning, license-savings tracking.
- **Ops at scale**: centralized monitoring of bloat, replication lag, connections, long transactions, slot lag;
  automated minor-version patching windows; DBA as platform team, not ticket queue.
