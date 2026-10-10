# Database Selection
Last reviewed: 2026-10 | Load when: choosing a data store

## Start from access patterns, not from fashion
Ask: entities & relationships? query shapes (point lookup, range, joins, aggregations, full-text,
similarity, graph traversal, time-range)? read/write ratio? volume & growth? latency? consistency &
transactions? multi-region? retention? team skills? budget?

## Decision table
| Workload | First choice | Alternatives |
|---|---|---|
| OLTP, relational, transactions, < ~10 TB | PostgreSQL (managed) | MySQL, SQL Server (MS shops), Oracle (legacy/licensed) |
| OLTP needing horizontal write scale + SQL + strong consistency, multi-region | Spanner / Aurora DSQL / CockroachDB / YugabyteDB | Citus (sharded Postgres) |
| Massive key-value / known access patterns, single-digit ms at any scale | DynamoDB / Cosmos DB / Bigtable | Cassandra/ScyllaDB |
| Flexible documents, rich queries | MongoDB (Atlas) / Cosmos DB / Firestore | Postgres JSONB |
| Write-heavy time-series/wide rows | Cassandra/ScyllaDB/Bigtable | Timestream, TimescaleDB, InfluxDB |
| Cache / sessions / leaderboards / rate limits | Redis/Valkey | Memcached (simple cache) |
| Durable in-memory primary DB | MemoryDB | Redis Enterprise with persistence |
| Full-text, faceted search, log analytics | OpenSearch / Elasticsearch | Azure AI Search, Algolia, Typesense |
| Analytics (OLAP) over TBs–PBs | Redshift / BigQuery / Snowflake / Fabric | Databricks SQL, ClickHouse (real-time) |
| Real-time analytics, sub-second on fresh data | ClickHouse / Apache Pinot / Druid | Rockset (acquired; discontinued), OpenSearch aggregations |
| Graph (relationships are the query) | Neptune / Neo4j / Cosmos Gremlin / Spanner Graph | Postgres recursive CTE for light use |
| Vector similarity | pgvector (if Postgres already) / OpenSearch k-NN | Pinecone, Weaviate, Qdrant, Milvus, S3 Vectors |
| Ledger / immutable audit | Append-only table + hash chain in Postgres | (QLDB is discontinued) |
| Object/blob | S3 / Blob / GCS (never BLOBs in OLTP DB) | |

## Polyglot persistence — rules
Each service owns its store; sync derived stores (search, cache, analytics) via CDC/events; define a
single source of truth per entity; accept eventual consistency on derived views.

## Relational vs NoSQL quick trade-offs
| | Relational | Key-value/Document NoSQL |
|---|---|---|
| Schema | Enforced, normalized | Flexible, denormalized per access pattern |
| Queries | Ad hoc, joins | Predefined access patterns |
| Scale | Vertical + replicas; sharding is hard | Horizontal by partition key |
| Transactions | Rich ACID | Limited (item/partition; some multi-item) |
| Best for | Evolving queries, integrity | Known, high-scale patterns |

## Interview phrasing
"Our access pattern is get-by-user-id and list-orders-by-user-sorted-by-date at 50k RPS with single-
digit-ms latency → DynamoDB with PK=userId, SK=orderDate#orderId. Ad hoc reporting goes to the
warehouse via streams, so I don't need joins in the OLTP store."
