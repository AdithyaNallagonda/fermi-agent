# AWS Glue
Last reviewed: 2026-10 ⚠️ Glue 5.0 (Spark 3.5, Python 3.11) GA Dec 2024; verify newer versions/pricing

## Components
- **Glue Data Catalog**: Hive-compatible metastore for S3 data (databases, tables, partitions); used by
  Athena, EMR, Redshift Spectrum, Lake Formation; supports Iceberg tables, statistics, optimizations
  (automatic compaction, snapshot retention, orphan file deletion for Iceberg).
- **Crawlers**: infer schema/partitions; prefer explicit DDL or partition projection (Athena) for
  predictable large datasets; crawlers can be slow/costly and mis-infer.
- **ETL jobs**: Spark (Python/Scala), Spark Streaming, Python shell (small jobs). Glue Studio (visual),
  notebooks / interactive sessions.
- **Glue Data Quality** (DQDL rules; recommendations), **DataBrew** (visual prep ⚠️ check status),
  Sensitive data detection, **Glue connections** (JDBC, SaaS connectors), workflows/triggers (simple
  orchestration; use Step Functions/MWAA for complex).
- **Glue Schema Registry** for Kafka/Kinesis (Avro/JSON Schema/Protobuf).

## Capacity & pricing
DPU = 4 vCPU + 16 GB. Worker types: G.1X, G.2X, G.4X, G.8X (memory-heavy), G.025X (streaming), R-type
memory-optimized ⚠️. Billed per DPU-hour with per-second billing (1-min minimum for Glue 2.0+).
**Flex execution** for non-urgent jobs (spare capacity, cheaper ~35%). **Auto Scaling** of workers.

## DynamicFrame vs DataFrame
DynamicFrame handles schema inconsistencies (choice types, `resolveChoice`), integrates with catalog,
bookmarks; Spark DataFrame has full API and optimizer. Common practice: read as DynamicFrame (or
directly via Spark), convert `toDF()`, transform in Spark, write.

## Job bookmarks
Track processed data (S3 files by modified time, JDBC by key columns) for incremental loads. Pitfalls:
bookmarks need `transformation_ctx`, consistent job names, and `job.commit()`; backfills require reset.
Many teams prefer explicit watermark tables or table-format incremental reads (Iceberg).

## Best practices
- Use Parquet + partitioning; push down predicates (`push_down_predicate`, `catalogPartitionPredicate`).
- Group small files (`groupFiles: inPartition`, `groupSize`).
- Iceberg/Delta/Hudi native support (`--datalake-formats`) for MERGE/upserts and ACID.
- Externalize config via job parameters; package libs as wheels (`--additional-python-modules`).
- Monitoring: CloudWatch job metrics, Spark UI (event logs to S3), job run insights; alarm on failures.
- Least-privilege job role; encryption (security configurations: S3, CloudWatch, bookmarks); VPC
  connections for JDBC with S3 gateway endpoint.
- Local development: Glue Docker images / interactive sessions; unit-test transformations separately.

## When Glue vs EMR vs others
| Need | Choose |
|---|---|
| Serverless Spark ETL, catalog-integrated, moderate tuning | Glue |
| Heavy/long-running, custom Spark/Hadoop tuning, cost-optimized with Spot, other frameworks (Hive, Presto, HBase, Flink) | EMR |
| Serverless Spark without Glue abstractions | EMR Serverless |
| SQL-only transforms over warehouse | dbt on Redshift/Athena |
| Small Python jobs | Glue Python shell / Lambda / ECS tasks |

## Interview angles
Design incremental S3 → curated lake pipeline with Glue + Iceberg MERGE; handling schema drift; cost
optimization (Flex, auto scaling, right worker type, file sizing).
