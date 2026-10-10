# Playbook: Data Platform / Pipeline Design

Knowledge: `knowledge/data-engineering/*`, `knowledge/databases/redshift.md`,
`knowledge/databases/cloud-data-warehouses.md`, `knowledge/fundamentals/messaging-and-streaming.md`.

1. **Sources & SLAs** — systems, volumes/day, change rate, formats, freshness SLA (batch daily /
   hourly / near-real-time / real-time), consumers (BI, ML, APIs, reverse ETL).
2. **Ingestion** — batch (Glue/ADF/Dataflow, file drops), CDC (DMS, Debezium, zero-ETL, Datastream),
   streaming (Kinesis/MSK/Event Hubs/Pub/Sub).
3. **Storage architecture** — medallion (bronze/raw → silver/cleansed → gold/curated) on object
   storage with an open table format (Iceberg/Delta/Hudi); catalog (Glue Data Catalog / Unity /
   Purview / Dataplex); warehouse for serving (Redshift/Snowflake/BigQuery/Fabric).
4. **Processing** — Spark (Glue/EMR/Databricks/Dataproc/Synapse), SQL (dbt on warehouse), Python
   (Polars/pandas for small data), Flink for streaming.
5. **Orchestration** — Airflow (MWAA/Composer), Step Functions, ADF, Dagster; idempotent, re-runnable
   tasks; backfill strategy.
6. **Quality & governance** — data contracts, Glue Data Quality / Great Expectations / dbt tests,
   lineage (OpenLineage), PII classification (Macie/Purview), row/column-level security (Lake
   Formation), retention.
7. **Performance & cost** — file sizing (128 MB–1 GB parquet), partitioning + clustering/Z-order,
   compaction, predicate pushdown, Spot/Flex execution, auto-scaling, warehouse WLM/concurrency.
8. **Operations** — monitoring of freshness/volume/schema drift, alerting, SLAs, runbooks, CI/CD for
   pipelines (unit tests with pytest + local Spark), environments.

Deliver: architecture diagram, layer definitions, pipeline DAG sketch, sample PySpark/Glue job,
cost estimate, backlog.

## Final step — Adversarial audit (mandatory)
Follow `instructions/adversarial-audit.md` as the senior reviewer of this work. Tier: **Standard**.
Apply: B (engines/formats/orchestrator), E (service limits, versions), D (sample jobs: syntax-check/run), R-check sizing/cost math. Fix Blockers before presenting; end with the 🔍 audit summary
(`principles/adversarial-self-audit.md`).
