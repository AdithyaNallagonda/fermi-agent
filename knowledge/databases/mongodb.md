# MongoDB (Atlas, DocumentDB)
Last reviewed: 2026-10 ⚠️ MongoDB 8.x current; verify

## Mental model
Document database (BSON), flexible schema, rich query language & aggregation pipeline, secondary
indexes, replica sets for HA, sharding for scale. WiredTiger storage engine (document-level concurrency,
compression).

## Key concepts
- Document max 16 MB. Schema design patterns: embedding vs referencing, bucket (time-series), outlier,
  computed, subset, extended reference, polymorphic, schema versioning.
- Replica set: primary + secondaries (Raft-like election); write concern (`w: "majority"`), read concern
  (`majority`, `linearizable`), read preference (primary, secondaryPreferred…).
- Sharding: shard key (hashed or ranged; compound), chunks/balancer, mongos routers, config servers.
  Shard key choice is critical (resharding supported since 5.0 but expensive).
- Multi-document ACID transactions (4.0+ replica sets, 4.2+ sharded) — use sparingly.
- Change streams for CDC. Time-series collections. Queryable Encryption.
- Atlas extras: Atlas Search (Lucene), Atlas Vector Search, Online Archive, global clusters, triggers.

## Amazon DocumentDB / Azure Cosmos DB for MongoDB
MongoDB API-compatible, not MongoDB itself — check feature compatibility (aggregation stages, change
streams, transactions limits). DocumentDB uses Aurora-like storage; elastic clusters for sharding.

## Performance
Indexes support queries (ESR rule: Equality, Sort, Range order for compound indexes); covered queries;
avoid unbounded arrays; use projection; `explain("executionStats")`; working set should fit in RAM.

## When to use
Rapidly evolving schemas, document-shaped data (catalogs, CMS, user profiles), developer velocity.
When not: heavy multi-entity transactions, complex joins/reporting (use a warehouse).

## Interview angles
Embedding vs referencing trade-off; shard key choice (cardinality, frequency, monotonicity); write
concern majority for durability.
