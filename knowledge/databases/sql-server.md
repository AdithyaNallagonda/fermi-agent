# Microsoft SQL Server & Azure SQL
Last reviewed: 2026-10 ⚠️ SQL Server 2025 (GA Nov 2025) adds native vector type/indexes and AI features — verify

## Mental model
Clustered index = table storage order (usually PK); nonclustered indexes with included columns;
buffer pool; transaction log (write-ahead; recovery models: Simple/Full/Bulk-logged); tempdb is a shared
hotspot; cost-based optimizer with plan cache (parameter sniffing!).

## Key features
Columnstore indexes (clustered/nonclustered) for analytics/HTAP; In-Memory OLTP (memory-optimized
tables); Query Store (plan regression detection & forcing); Intelligent Query Processing; temporal tables;
Always Encrypted (client-side encryption, secure enclaves); TDE; Row-Level Security; Dynamic Data Masking;
ledger tables; JSON support (native json type in newer versions); PolyBase; Change Data Capture & Change
Tracking.

## Isolation & concurrency
Default Read Committed with locking; enable **RCSI** (Read Committed Snapshot Isolation) to avoid
reader/writer blocking (row versions in tempdb; Azure SQL DB has it on by default). Snapshot isolation
for transactions. Watch lock escalation and deadlocks (Extended Events / system_health).

## HA/DR
Always On Availability Groups (sync/async replicas, readable secondaries, listener; contained AGs),
Failover Cluster Instances (shared storage), log shipping, distributed AGs for DR across sites.

## Azure options
| Option | When |
|---|---|
| Azure SQL Database (single/elastic pools) | Cloud-native apps; vCore GP/BC/Hyperscale; serverless auto-pause |
| Hyperscale | Up to ~128 TB, fast scale, named/HA/geo replicas, rapid backups |
| Azure SQL Managed Instance | Lift-and-shift needing instance features (SQL Agent, cross-DB queries, CLR) |
| SQL Server on Azure VM | Full control, unsupported features, specific versions |
| RDS for SQL Server (AWS) | Managed on AWS; license-included or BYOL constraints |
Failover groups for geo-DR with listener endpoints; Business Critical gives in-region readable replica.

## Performance levers
Query Store + execution plans; fix parameter sniffing (OPTIMIZE FOR, recompile hints, PSP optimization
in 2022+); proper indexing (missing index DMVs as hints, not gospel); avoid scalar UDFs on large sets
(inlining helps in 2019+); tempdb multiple files; MAXDOP/cost threshold tuning; batch mode on rowstore.

## Licensing (cost drivers)
Per-core licensing (Enterprise vs Standard), Software Assurance, Azure Hybrid Benefit, license-included
on cloud; Enterprise features (online index ops, AG readable secondaries, partitioning now in Standard
since 2016 SP1).

## Interview angles
RCSI vs NOLOCK (NOLOCK = dirty reads, skipped/duplicate rows — avoid); AG vs FCI; MI vs SQL DB;
migrating to Azure (Azure Migrate/DMS, assess compatibility).
