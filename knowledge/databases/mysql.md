# MySQL (and managed variants)
Last reviewed: 2026-10 ⚠️ MySQL 8.0 reached EOL April 2026; 8.4 is LTS; 9.x innovation releases — verify

## Mental model
Pluggable storage engines — **InnoDB** (default): clustered index on primary key (rows stored in PK
order; secondary indexes store PK), MVCC with undo logs, redo log, buffer pool, row-level locking with
gap/next-key locks under Repeatable Read (default isolation).

## Key design implications
- Primary key choice matters a lot: monotonic (auto-increment/UUIDv7/ordered) avoids page splits;
  random UUIDv4 PKs hurt insert performance and inflate secondary indexes.
- Secondary index lookups → PK lookup (covering indexes avoid the second lookup).
- Gap locks can cause deadlocks under RR; many OLTP apps use Read Committed.

## Replication & HA
Async binlog replication (row-based), semi-sync, GTIDs, Group Replication / InnoDB Cluster (Paxos-
based, single-primary mode), InnoDB ClusterSet for DR. Orchestrator/ProxySQL in self-managed fleets.
Vitess (YouTube, PlanetScale) for horizontal sharding.

## Managed options
RDS for MySQL (Multi-AZ instance/cluster deployments), **Aurora MySQL** (distributed storage, up to 15
replicas, Global Database, Serverless v2, fast cloning, backtrack), Azure Database for MySQL Flexible
Server, Cloud SQL for MySQL, HeatWave (Oracle, in-memory analytics), PlanetScale (Vitess).

## Performance levers
Buffer pool ~70–80% RAM on dedicated hosts; `innodb_flush_log_at_trx_commit` (1 = durable; 2 = faster,
risk of ~1 s loss); connection pooling (ProxySQL/RDS Proxy); avoid `SELECT *`; use `EXPLAIN ANALYZE`;
online DDL / gh-ost / pt-online-schema-change for big tables; partitioning for retention.

## MySQL vs PostgreSQL (when asked)
| | MySQL | PostgreSQL |
|---|---|---|
| Strengths | Simple, fast for read-heavy web OLTP, mature replication, huge ecosystem | Richer SQL & types, extensibility (PostGIS, pgvector), stricter standards, complex queries |
| Weaknesses | Fewer advanced features, weaker for analytics-ish queries | Vacuum management, process-per-connection |
Choose by team skill and ecosystem; both are fine for most OLTP.

## Gotchas
utf8 vs **utf8mb4** (always utf8mb4); implicit type conversions disabling indexes; long transactions
growing undo/history list; replica lag under large transactions; `ONLY_FULL_GROUP_BY`.
