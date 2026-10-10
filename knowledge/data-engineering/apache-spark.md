# Apache Spark
Last reviewed: 2026-10 ⚠️ Spark 4.0 released 2025 (ANSI mode default, Spark Connect, VARIANT type)

## Mental model
Driver builds a logical plan → Catalyst optimizer → physical plan → DAG of **stages** split at
**shuffle** boundaries → **tasks** (one per partition) on executors. Lazy evaluation; actions trigger jobs.
Tungsten: off-heap memory, whole-stage codegen. **AQE** (Adaptive Query Execution) re-optimizes at runtime
(coalesce shuffle partitions, switch join strategies, handle skew).

## Joins
Broadcast hash join (small side < `spark.sql.autoBroadcastJoinThreshold`, default 10 MB; raise
carefully), sort-merge join (large-large), shuffle hash join. Skew: AQE skew join, salting, isolate hot
keys.

## Partitioning
- Input partitions from file splits (`spark.sql.files.maxPartitionBytes`, 128 MB default).
- Shuffle partitions `spark.sql.shuffle.partitions` (200 default) — with AQE coalescing, set high & let
  AQE shrink. Target ~100–200 MB per partition.
- `repartition(n, col)` (full shuffle) vs `coalesce(n)` (narrow, reduce only).
- Write: `partitionBy` low-cardinality columns (date), avoid small files (target 128 MB–1 GB files),
  bucketing for repeated joins.

## Memory & executors
Executor memory = heap (execution + storage unified) + overhead (~10%, more for PySpark). Typical
executor: 4–5 cores, 16–32 GB. Spill to disk signals memory pressure. Dynamic allocation with shuffle
tracking. Cache only reused DataFrames; `unpersist`.

## Performance checklist
1. Read less: column pruning, predicate pushdown, partition pruning (Parquet/ORC/Iceberg/Delta).
2. Avoid Python UDFs → use built-in functions; else pandas UDFs (Arrow).
3. Broadcast small dims; handle skew.
4. Right-size shuffle partitions; enable AQE (default on).
5. Avoid `collect()` on big data; avoid wide `groupByKey` on RDDs.
6. Use Spark UI: stages with long tail tasks (skew), spill, GC time, shuffle read/write sizes.
7. Compaction of small files; Z-order/clustering (Delta/Iceberg).

## Structured Streaming
Micro-batch (default) / continuous; sources (Kafka, Kinesis, files); watermarks for late data; stateful
aggregations with state store (RocksDB); checkpointing for exactly-once to idempotent/transactional sinks;
trigger intervals; `foreachBatch` for MERGE upserts.

## Platforms
AWS Glue, EMR (EC2/EKS/Serverless), Databricks (Photon, Delta, Unity Catalog), Dataproc, Fabric/Synapse
Spark, HDInsight (legacy).

## Interview angles
Explain a shuffle; fix a skewed join; why small files are bad; narrow vs wide transformations; how AQE
helps; exactly-once in streaming.
