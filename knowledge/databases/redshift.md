# Amazon Redshift
Last reviewed: 2026-10 ⚠️ verify node types, RPU minimums, features via `aws-docs`

## Mental model
MPP columnar data warehouse: leader node plans/compiles; compute nodes (slices) execute in parallel on
columnar, compressed data. Performance = minimize data scanned and data shuffled between nodes.

## Deployment options
- **RA3 provisioned** (ra3.large/xlplus/4xlarge/16xlarge): compute separated from Redshift Managed
  Storage (RMS) on S3 with local SSD cache. DC2 is legacy.
- **Redshift Serverless**: capacity in RPUs (base capacity configurable, small minimums for light
  workloads ⚠️), pay per RPU-hour while active; AI-driven scaling & optimization options.
- **Data sharing** across clusters/accounts/regions (live, no copy) — workload isolation (ETL vs BI),
  data mesh. Multi-data warehouse writes through data sharing.

## Table design
| Lever | Options | Guidance |
|---|---|---|
| Distribution style | AUTO, EVEN, KEY, ALL | KEY on large fact + dimension join column to co-locate; ALL for small dims; AUTO default is good |
| Sort key | Compound (default), Interleaved (rarely), AUTO | Columns in range filters (dates) first; enables zone-map block skipping |
| Compression | AZ64 (numeric/date), ZSTD, LZO; ENCODE AUTO | Let COPY/auto choose |
| Constraints | PK/FK informational only | Not enforced; optimizer uses them |
Automatic Table Optimization (ATO) can choose dist/sort keys from workload.

## Loading & integration
`COPY` from S3 (parallel; split files into multiples of slices; Parquet/ORC/CSV/JSON), auto-copy from
S3, streaming ingestion from Kinesis/MSK (materialized views), **zero-ETL** from Aurora/RDS/DynamoDB and
some SaaS apps, Spectrum (query S3 data lake via Glue Catalog, incl. Iceberg), federated queries to
Aurora/RDS Postgres/MySQL, `UNLOAD` to S3 Parquet.

## Performance features
Materialized views (incremental + auto refresh, automated MVs), result caching, concurrency scaling
(burst clusters for read & some write queries), automatic WLM with query priorities, short query
acceleration, Redshift ML (SageMaker), vacuum/analyze automatic (still check heavily updated tables).

## Query tuning
Check `EXPLAIN` for `DS_BCAST_INNER`/`DS_DIST_BOTH` (data redistribution); filter on sort key;
avoid `SELECT *`; use late-binding views carefully; system tables `SYS_QUERY_HISTORY`, `STL_ALERT_EVENT_LOG`,
`SVV_TABLE_INFO` (skew, unsorted %, stats off).

## Security
VPC, enhanced VPC routing, IAM/Identity Center integration, RBAC, row-level security, column-level
grants, dynamic data masking, KMS encryption, audit logging, Lake Formation permissions for Spectrum.

## Cost levers
Reserved nodes for steady provisioned, Serverless for intermittent, pause/resume provisioned, base RPU
sizing & max RPU limits, concurrency scaling free credits (1 h per day accrual ⚠️), data sharing vs
duplicating clusters, Spectrum scans of partitioned Parquet only.

## Redshift vs others
vs Snowflake (multi-cloud, per-second virtual warehouses, simpler ops), vs BigQuery (serverless slots,
GCP), vs Athena (serverless ad hoc on S3, pay per TB scanned). Choose Redshift for AWS-native steady
BI with deep integrations (zero-ETL, Lake Formation, QuickSight).

## Interview angles
Star schema design with dist/sort keys; handling skew; near-real-time ingestion (streaming ingestion /
zero-ETL); workload isolation (data sharing).
