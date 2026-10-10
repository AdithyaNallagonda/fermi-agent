# Cassandra & Wide-Column Stores (ScyllaDB, Keyspaces, Bigtable, HBase)
Last reviewed: 2026-10

## Mental model (Cassandra)
Leaderless, Dynamo-style ring with consistent hashing + vnodes; Bigtable-style storage (LSM: commit
log → memtable → SSTables, compaction). Tunable consistency per query: ONE, QUORUM, LOCAL_QUORUM, ALL.
Multi-datacenter replication (NetworkTopologyStrategy). Writes are very fast; reads cost more.

## Data modeling (query-first)
- Table per query. Primary key = **partition key** (distribution) + **clustering columns** (sort within
  partition). `PRIMARY KEY ((user_id, month), event_time)` → bounded partitions via time bucketing.
- Keep partitions < ~100 MB and < ~100k rows (rule of thumb); avoid unbounded partitions.
- Denormalize; no joins; limited secondary indexes (SAI in Cassandra 5.0 improves this).
- Tombstones from deletes/TTL hurt reads — avoid queue-like delete patterns.
- Lightweight transactions (Paxos, `IF NOT EXISTS`) are expensive; use sparingly. Cassandra 5.0 adds
  SAI, vector search; Accord transactions in progress ⚠️.

## Compaction strategies
STCS (write-heavy), LCS (read-heavy, more I/O), TWCS (time-series with TTL), UCS (Cassandra 5.0 unified).

## Variants
| Option | Notes |
|---|---|
| ScyllaDB | C++ rewrite, shard-per-core, much higher per-node throughput, Cassandra/DynamoDB-compatible APIs |
| Amazon Keyspaces | Serverless Cassandra-compatible (CQL), on-demand/provisioned |
| Azure Managed Instance for Apache Cassandra / Cosmos DB Cassandra API | Managed options |
| Google Bigtable | Wide-column (HBase API), single-row transactions, row key design critical, autoscaling, replication |
| HBase | Hadoop ecosystem, HDFS-backed |

## Bigtable row key design
Avoid monotonically increasing prefixes (timestamps) → hotspotting; use field promotion, salting,
reversed timestamps; keep related data adjacent; row size < 100 MB (ideally much less).

## Use for
Time-series, IoT, messaging inboxes, activity feeds, write-heavy high-volume workloads, multi-DC active-
active. Not for ad hoc queries, strong multi-row transactions, small datasets.

## Interview angles
Design a chat message store: PK=(conversation_id, bucket), CK=message_ts DESC; LOCAL_QUORUM; TTL
policy; explain hinted handoff/read repair.
