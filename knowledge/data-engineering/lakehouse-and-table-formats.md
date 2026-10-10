# Lakehouse & Open Table Formats
Last reviewed: 2026-10 ⚠️

## Why table formats
Plain Parquet on S3 lacks ACID, updates/deletes, schema evolution, time travel, and safe concurrent
writes. Table formats add a metadata layer (snapshots/manifests or transaction logs) on object storage.

## Comparison
| | Apache Iceberg | Delta Lake | Apache Hudi |
|---|---|---|---|
| Metadata | Snapshots → manifest lists → manifests | `_delta_log` JSON + checkpoints | Timeline, file groups |
| Strengths | Engine-neutral (Spark, Trino, Flink, Athena, Redshift, Snowflake, BigQuery, DuckDB), hidden partitioning, partition evolution | Databricks ecosystem, mature MERGE, liquid clustering, UniForm (Iceberg-readable) | Upsert-heavy CDC, incremental pulls, record-level index |
| Catalogs | REST catalog, Glue, Polaris, Nessie, Unity (Iceberg REST), S3 Tables | Unity Catalog, Hive/Glue | Hive/Glue |
Industry momentum strongly favors **Iceberg** as the interoperable standard (S3 Tables, Snowflake, BigQuery
BigLake, Databricks support). Iceberg v3 spec adds deletion vectors, row lineage, variant type ⚠️.

## Medallion architecture
- **Bronze (raw)**: immutable landing, source-shaped, append-only, full history.
- **Silver (cleansed/conformed)**: deduped, typed, validated, joined to master data, SCD handling.
- **Gold (curated)**: business-level aggregates/marts, served to BI/ML/APIs.

## Table maintenance
Compaction (rewrite small files), expire snapshots, remove orphan files, rewrite manifests, sort/
Z-order/clustering for data skipping, merge-on-read vs copy-on-write trade-off (write vs read speed).
AWS: Glue Data Catalog automatic optimization, **S3 Tables** (managed Iceberg with automatic
maintenance).

## AWS lakehouse stack
S3 (+ S3 Tables) → Glue Data Catalog → **Lake Formation** (fine-grained row/column/cell permissions,
LF-tags (ABAC), cross-account sharing) → engines: Athena (serverless SQL; per TB scanned or provisioned
capacity), Redshift Spectrum, EMR, Glue → SageMaker Unified Studio / Lakehouse ⚠️ branding. Athena tips:
partition projection, Parquet + compression, CTAS/INSERT for materialization, workgroups with scan limits.

## Azure / GCP equivalents
Azure: ADLS Gen2 + Fabric OneLake (Delta) + Purview / Unity Catalog (Databricks). GCP: Cloud Storage +
BigLake (Iceberg) + Dataplex + BigQuery.

## Data mesh (organizational)
Domain-oriented ownership, data as a product (SLAs, docs, discoverability), self-serve platform,
federated computational governance. Technically: per-domain accounts/catalogs + central catalog sharing
(Lake Formation, DataZone/SageMaker Catalog, Unity Catalog, Purview).

## Interview angles
Lake vs warehouse vs lakehouse; implementing CDC upserts (MERGE INTO Iceberg); GDPR delete in a lake
(row-level deletes + snapshot expiry); small-files problem.
