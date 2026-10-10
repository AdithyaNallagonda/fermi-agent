# DBA Fundamentals (cross-engine)
Last reviewed: 2026-10 | Load when: database operations, tuning, backup/HA design, DBA interviews.
Engine details: `databases/postgresql.md`, `mysql.md`, `sql-server.md`, `oracle.md`, `mongodb.md`,
`cassandra-and-wide-column.md`, `redis.md`, `dynamodb.md`, `cosmos-db.md`. Commands: `dba-diagnostics-cheatsheet.md`.

## Indexing
- B-tree: equality + range + ORDER BY; composite column order = equality columns → range column → sort; leftmost-
  prefix rule; covering/INCLUDE indexes avoid lookups; partial/filtered indexes for skewed predicates; expression/
  function-based indexes for computed predicates.
- Other types: hash (equality), GIN/inverted (arrays, JSON, full-text), GiST/spatial, BRIN/zone maps (huge
  naturally ordered tables), bitmap (low-cardinality analytics — Oracle/warehouses), columnstore (analytics).
- Costs: every index slows writes and uses memory/storage; find unused/duplicate indexes periodically; index FKs
  used in joins/deletes.
- Selectivity & cardinality drive usefulness; low-selectivity predicates often scan anyway.

## Query optimization essentials
Cost-based optimizers depend on **statistics** — stale/missing stats → bad cardinality estimates → bad plans.
Common killers: functions/implicit casts on indexed columns, leading-wildcard LIKE, OR across columns, N+1 from
ORMs, SELECT *, OFFSET pagination, non-sargable predicates, correlated subqueries, parameter sniffing / plan
caching with skewed data, missing join predicates, sorts/hashes spilling to disk. Read plans for estimated vs
actual rows first.

## Concurrency
Isolation levels (Read Uncommitted → Read Committed → Repeatable Read → Snapshot → Serializable) and their
anomalies (dirty read, non-repeatable read, phantom, write skew, lost update). MVCC (Postgres, Oracle, InnoDB, SQL
Server RCSI/SI) lets readers not block writers but needs cleanup (vacuum/undo/version store). Locking: row/page/
table, lock escalation, intent locks, gap/next-key locks (InnoDB RR). Deadlocks: consistent access order, short
transactions, proper indexes, retry logic. Optimistic concurrency (version columns) for web apps.

## Storage & memory
Buffer pool/shared buffers + OS cache; WAL/redo/transaction log first then data pages (checkpoints); log I/O
latency limits commit throughput; temp/tempdb usage for sorts/hashes; fragmentation & bloat; fill factor;
page/row compression; tablespace/filegroup layout on self-managed.

## Backup & recovery concepts
Full · differential · incremental · log/WAL/binlog for **PITR** · snapshots (crash- vs app-consistent) · logical
dumps (portable, slow at scale) · physical (fast, version-bound). RPO = data loss tolerance; RTO = time to restore
service (includes detection, decision, restore, recovery, validation). 3-2-1(-1-0) rule: 3 copies, 2 media, 1
offsite, 1 immutable, 0 restore errors (tested). Verify backups (checksums, DBCC CHECKDB / pg_amcheck, restore
tests).

## HA & DR patterns
Primary + synchronous standby (zero data loss, latency cost) · async replicas (lag, possible loss) · quorum
commit/consensus (Raft/Paxos — distributed SQL) · shared-storage clusters (RAC, FCI, Aurora storage) · log
shipping · multi-region (global databases). Avoid split-brain with quorum/witness + fencing. Managed services:
Multi-AZ, Aurora Global Database, Azure failover groups, Cloud SQL HA, cross-region replicas.

## Scaling
Vertical → read replicas → caching → connection pooling → partitioning (range/list/hash; partition pruning;
drop-partition retention) → functional split → sharding (app-level, Citus, Vitess, Aurora Limitless) → distributed
SQL. Each step adds operational complexity; justify with metrics.

## Data lifecycle
Retention policies, archival tables/partitions, purge in batches (avoid giant deletes → bloat/log growth/replication
lag), legal hold, PII minimization, test data masking for non-prod (never copy raw prod PII).

## Observability (what to monitor)
Latency & throughput (QPS/TPS), top SQL by total time, waits, CPU/memory/IO, connections & pool saturation, locks/
deadlocks, replication lag, storage growth/free space, long transactions, cache hit ratios, errors, autovacuum/
maintenance progress, backup success & age, certificate/credential expiry. Tools: engine views + Prometheus
exporters/Grafana, Datadog/New Relic DB monitoring, cloud tools (CloudWatch Database Insights, Azure Query
Performance Insight/Query Store, Cloud SQL Query Insights) ⚠️ product names evolve.

## DBA interview angles
Explain MVCC and vacuum/undo; diagnose a sudden slowdown (method A in `instructions/dba-operations.md`); design
backups for RPO 5 min / RTO 1 h; zero-downtime column type change on a 2 TB table (expand/contract + batched
backfill + dual writes); handle a deadlock storm; when to partition vs shard.
