# Oracle Database
Last reviewed: 2026-10 ⚠️ Oracle AI Database 26ai naming/release — verify

## Mental model
Instance (SGA: buffer cache, shared pool; PGA per session; background processes) + database (datafiles,
redo logs, control files, undo). Multitenant architecture: CDB with PDBs (pluggable databases).
Read consistency via undo; default isolation Read Committed; readers never block writers.

## Enterprise features
RAC (Real Application Clusters — shared-disk active-active across nodes in a site), Data Guard (physical/
logical standby; Active Data Guard read-only standby; Far Sync), GoldenGate (logical replication, CDC,
bi-directional), partitioning (range/list/hash/interval/reference), Exadata (engineered system with
smart scan offload), In-Memory column store, Automatic Storage Management (ASM), Flashback, TDE,
Database Vault, VPD (row-level security), AI Vector Search (23ai+), JSON Relational Duality.

## Cloud options
Oracle Database@AWS / @Azure / @Google Cloud (Exadata in hyperscaler datacenters), OCI Autonomous
Database, RDS for Oracle (no RAC), EC2/VM self-managed. Licensing complexity (processor core factors,
cloud vCPU rules, named user plus) is a major cost and audit risk — involve licensing specialists.

## Migration off Oracle (common SA engagement)
1. Assess (schema complexity, PL/SQL volume, features used) — AWS SCT / DMS Schema Conversion, Ora2Pg,
   Azure Database Migration, Google Database Migration Service.
2. Target: PostgreSQL (Aurora/Azure Flexible/AlloyDB) most common.
3. Convert schema + PL/SQL → PL/pgSQL (packages, autonomous transactions, hierarchical queries,
   sequences, date semantics, empty string = NULL in Oracle!).
4. Data migration with CDC (DMS, GoldenGate) for minimal downtime cutover.
5. Test performance (plans differ), app SQL changes, cutover runbook, rollback plan.

## Interview angles
RAC vs Data Guard (scale/HA in-site vs DR); why customers leave Oracle (licensing/TCO, cloud-native);
risks in migration (PL/SQL, performance regressions, hidden app dependencies).
