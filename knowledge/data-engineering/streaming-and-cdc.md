# Streaming Pipelines & Change Data Capture
Last reviewed: 2026-10 ⚠️ verify service limits

## Streaming platforms
| Service | Unit of scale | Notes |
|---|---|---|
| Kinesis Data Streams | Shards (1 MB/s or 1,000 rec/s in; 2 MB/s out per shard) or on-demand mode | Enhanced fan-out (2 MB/s per consumer per shard), retention 24 h–365 days |
| Amazon Data Firehose | Managed delivery | Buffer → S3/Redshift/OpenSearch/Splunk/Iceberg tables; transform via Lambda; format conversion to Parquet |
| Amazon MSK | Kafka brokers (provisioned, Express brokers, Serverless) | MSK Connect for connectors; tiered storage |
| Event Hubs | Throughput/processing units, partitions | Kafka endpoint; Capture to ADLS |
| Google Pub/Sub / Managed Service for Apache Kafka | Serverless | BigQuery subscriptions |
| Confluent Cloud | Kafka SaaS | Flink SQL, schema registry, connectors, Tableflow (Iceberg) |

## Stream processing
- **Apache Flink** (Amazon Managed Service for Apache Flink, Confluent, Ververica): true streaming, event
  time, watermarks, exactly-once state (checkpoints), windows (tumbling, sliding, session), CEP, Flink SQL.
- Spark Structured Streaming (micro-batch), Kafka Streams/ksqlDB (JVM, Kafka-native), Lambda/Functions
  for simple per-record processing, Dataflow (Beam).

## Time semantics
Event time vs processing time; watermarks bound lateness; allowed lateness + side outputs for late
events; idempotent sinks or upserts for corrections.

## CDC
| Method | Tools | Notes |
|---|---|---|
| Log-based (WAL/binlog/redo) | Debezium (Kafka Connect), AWS DMS, Datastream, Fivetran/Airbyte, GoldenGate | Low impact, captures deletes; needs replication slots/binlog row format |
| Zero-ETL (managed) | Aurora/RDS/DynamoDB → Redshift; DynamoDB/DocumentDB → OpenSearch; Fabric mirroring | No pipeline code; limited transforms |
| Query-based (timestamps) | Custom | Misses deletes; load on source |
| DB-native streams | DynamoDB Streams, Cosmos DB change feed, MongoDB change streams | Event-driven app integration |
Postgres gotcha: inactive logical replication slots retain WAL → disk fills. Monitor slot lag.

## Patterns
- **Kappa** (single streaming path, replay from log) vs **Lambda architecture** (batch + speed layers —
  mostly obsolete with table formats + streaming).
- Stream → lakehouse: Kafka → Flink/Spark → Iceberg (upserts) → warehouse/BI.
- Real-time features for ML: stream → feature store online (Redis/DynamoDB) + offline (lake).
- Outbox → CDC → Kafka for reliable domain events.

## Interview angles
Design real-time fraud detection (stream enrichment with state, < 1 s decision, model scoring, feature
store); exactly-once from Kafka to DB; handling late and out-of-order events.
