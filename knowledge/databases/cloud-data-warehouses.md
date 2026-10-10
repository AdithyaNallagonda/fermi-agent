# Cloud Data Warehouses & OLAP Engines
Last reviewed: 2026-10 ⚠️

## Comparison
| Engine | Model | Strengths | Watch |
|---|---|---|---|
| Snowflake | Storage/compute separation; virtual warehouses (per-second billing); multi-cloud | Simplicity, data sharing/marketplace, Iceberg tables, Cortex AI, Snowpark | Credit spend governance (auto-suspend, resource monitors) |
| BigQuery | Serverless; slots (on-demand per TB scanned or editions with autoscaling slots) | Zero ops, BigLake/Iceberg, BQML, streaming, Gemini in BigQuery | Scan costs — partition & cluster; `SELECT *` expensive |
| Amazon Redshift | MPP, RA3/Serverless | AWS integration, zero-ETL | Table design matters (see `redshift.md`) |
| Microsoft Fabric Warehouse | SaaS, OneLake (Delta/Parquet), capacity units (F SKUs) | Unified with Power BI, Data Factory, Spark | Capacity planning & throttling/smoothing |
| Azure Synapse Analytics | Dedicated SQL pools (MPP), serverless SQL, Spark | Existing estates | New investments trending to Fabric |
| Databricks SQL | Lakehouse on Delta/Iceberg, Photon engine, serverless SQL warehouses | Unified ML + BI, Unity Catalog | DBU costs |
| ClickHouse | Columnar OLAP, MergeTree, real-time | Sub-second analytics on fresh event data, cheap | Joins/updates limitations; ops if self-hosted |
| Apache Pinot / Druid | Real-time OLAP | User-facing analytics at high QPS | Ops complexity |
| DuckDB / MotherDuck | In-process OLAP | Local analytics, small/medium data, CI testing | Single-node |

## Modeling
- **Kimball dimensional**: star schema (facts + conformed dimensions), SCD Type 1/2 (history), surrogate
  keys, grain declaration first.
- **Data Vault 2.0**: hubs/links/satellites for auditability and integration of many sources; serve
  stars on top.
- **One Big Table (OBT)**: denormalized wide tables for columnar engines — fast, simple, duplication.
- Medallion layers in lakehouses (bronze/silver/gold). dbt for transformations, tests, docs, lineage.

## Performance levers (universal)
Partition pruning (date), clustering/sort keys, materialized views/aggregates, columnar file sizing,
avoid tiny files, result caches, workload isolation (separate warehouses/pools), predicate pushdown.

## Cost governance
Auto-suspend/auto-scale limits, quotas/budgets per team, query tags for chargeback, kill runaway queries,
monitor top-N expensive queries weekly, storage lifecycle (time travel retention).

## Interview angles
Warehouse vs lake vs lakehouse; when to choose real-time OLAP (ClickHouse/Pinot) for user-facing
dashboards vs warehouse for internal BI.
