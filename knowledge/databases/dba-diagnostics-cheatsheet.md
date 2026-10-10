# DBA Diagnostics Cheat Sheet (per engine)
Last reviewed: 2026-10 ⚠️ Syntax/view names vary by version and managed service — confirm against the exact
version's docs before running; all commands below are **read-only diagnostics** unless marked ⚠️WRITE.

## PostgreSQL
- Activity & blocking: `pg_stat_activity` (state, wait_event_type/wait_event, query_start, xact_start);
  `pg_blocking_pids(pid)`; `pg_locks`.
- Top SQL: `pg_stat_statements` extension (total_exec_time, calls, mean_exec_time, shared_blks_read).
- Plans: `EXPLAIN (ANALYZE, BUFFERS) <query>` (ANALYZE executes the query — careful with DML; wrap in
  `BEGIN … ROLLBACK`); `auto_explain` for slow plans.
- Tables/indexes: `pg_stat_user_tables` (seq_scan, n_dead_tup, last_autovacuum), `pg_stat_user_indexes`
  (idx_scan = 0 → unused candidates), `pg_relation_size`/`pg_total_relation_size`.
- Wraparound risk: `age(datfrozenxid)` from `pg_database`.
- Replication: `pg_stat_replication` (primary), `pg_stat_wal_receiver` (standby), `pg_replication_slots`
  (inactive slots retain WAL!).
- Tools: pgBadger (log analysis), pg_repack (online bloat removal ⚠️WRITE), pgBackRest/Barman (backups),
  `pg_amcheck` (corruption checks).

## MySQL / MariaDB
- Activity: `SHOW PROCESSLIST` / `performance_schema.threads`; locks: `performance_schema.data_locks`,
  `data_lock_waits`; `SHOW ENGINE INNODB STATUS` (latest deadlock, buffer pool, history list length).
- Top SQL: `performance_schema.events_statements_summary_by_digest`; `sys.statement_analysis`; slow query log +
  `pt-query-digest`.
- Plans: `EXPLAIN FORMAT=TREE`, `EXPLAIN ANALYZE` (8.0.18+; executes the query).
- Schema health: `sys.schema_unused_indexes`, `sys.schema_redundant_indexes`, `information_schema.TABLES`.
- Replication: `SHOW REPLICA STATUS` (8.0.22+ naming; older: `SHOW SLAVE STATUS`).
- Backups/changes: Percona XtraBackup / MySQL Enterprise Backup (physical), MySQL Shell dump utilities
  (`util.dumpInstance`, parallel) or mysqldump (logical); **`mysqlpump` removed in 8.4**; online DDL via
  `ALGORITHM=INPLACE/INSTANT`, gh-ost, pt-online-schema-change (⚠️WRITE).
- Lifecycle: MySQL 8.0 reached EOL April 2026 → plan 8.4 LTS.

## SQL Server / Azure SQL
- Activity: `sys.dm_exec_requests` + `sys.dm_exec_sessions` + `sys.dm_exec_sql_text`; blocking via
  `blocking_session_id`; community `sp_WhoIsActive`.
- Waits: `sys.dm_os_wait_stats` (cumulative; diff two snapshots), `sys.dm_exec_session_wait_stats`.
- Top SQL & regressions: **Query Store** (top resource consumers, regressed queries, plan forcing);
  `sys.dm_exec_query_stats`.
- Indexes: `sys.dm_db_index_usage_stats`, `sys.dm_db_missing_index_details` (hints, not gospel),
  `sys.dm_db_index_physical_stats` (fragmentation).
- Tracing: Extended Events (`system_health` captures deadlocks).
- Integrity & maintenance: `DBCC CHECKDB` (heavy — schedule), Ola Hallengren maintenance solution; backups
  FULL/DIFF/LOG; HA: `sys.dm_hadr_*` for Always On AGs.

## Oracle
- Activity: `V$SESSION` (event, blocking_session, sql_id), `V$SQL`/`V$SQLSTATS`; plans: `DBMS_XPLAN.DISPLAY_CURSOR`.
- **Licensing caution**: AWR/ASH/ADDM require the Diagnostics Pack and SQL Tuning Advisor the Tuning Pack
  (Enterprise Edition options) — don't query `DBA_HIST_*`/`V$ACTIVE_SESSION_HISTORY` on unlicensed systems; use
  Statspack instead.
- Backups: RMAN (incremental, block change tracking, validate), Data Pump `expdp/impdp` (logical); Data Guard
  status: `V$DATAGUARD_STATS`, `V$ARCHIVE_DEST_STATUS`.

## MongoDB
`db.currentOp()`, `db.serverStatus()`, `explain("executionStats")`, database profiler (slowms), `$indexStats`
aggregation (unused indexes), `rs.status()` (replica lag), `sh.status()` (sharding/balancer); backups:
mongodump/mongorestore (logical), Atlas/Ops Manager snapshots + PITR.

## Cassandra / ScyllaDB
`nodetool status`, `tpstats` (pending/blocked/dropped), `tablestats`/`cfstats`, `tablehistograms` (partition size,
latency), `compactionstats`, `repair` (⚠️ heavy — schedule; incremental/subrange), query `TRACING ON`; watch
tombstone warnings and large-partition logs.

## Redis / Valkey
`INFO` (memory, stats, replication, persistence), `SLOWLOG GET`, `LATENCY DOCTOR`, `MEMORY USAGE <key>`,
`redis-cli --bigkeys` / `--memkeys` (SCAN-based), `CLIENT LIST`; avoid `KEYS *` and `MONITOR` in production.

## DynamoDB / Cosmos DB (managed NoSQL)
DynamoDB: CloudWatch (ConsumedRead/WriteCapacity, ThrottledRequests, SystemErrors), **Contributor Insights** (hot
keys), PITR status, global table replication latency. Cosmos DB: Azure Monitor (Total Request Units, 429s by
partition), diagnostic logs (`PartitionKeyRUConsumption`), Insights blade for hot partitions.

## Managed-service monitoring
AWS: CloudWatch Database Insights (fleet + per-instance analysis, on-demand analysis for RDS SQL Server/Oracle)
and Enhanced Monitoring; Performance Insights status ⚠️ verify. Azure: Query Store, Query Performance Insight,
Intelligent Insights, Database watcher ⚠️. GCP: Cloud SQL Query Insights / AlloyDB query insights.
