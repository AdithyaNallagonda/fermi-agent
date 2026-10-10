# Amazon DynamoDB
Last reviewed: 2026-10 ⚠️ verify limits/pricing via `aws-docs`

## Mental model
Managed, serverless, partitioned key-value/document store. Data is hashed by **partition key** to
partitions; items within a partition are sorted by **sort key**. You design tables around **access
patterns**, not entities.

## Key limits (⚠️ verify)
- Item size max **400 KB** (store big payloads in S3, pointer in item).
- Per-partition throughput ~**3,000 RCU and 1,000 WCU** (adaptive capacity & split-for-heat help).
- 1 RCU = 1 strongly consistent read/s of ≤ 4 KB (or 2 eventually consistent); 1 WCU = 1 write/s ≤ 1 KB.
- Query/Scan return ≤ 1 MB per page. BatchGetItem 100 items/16 MB; BatchWriteItem 25 items.
- Transactions: up to **100 items** / 4 MB per TransactWriteItems/TransactGetItems (2× capacity cost).
- GSIs: default quota 20 per table; LSIs: ≤ 5, **only at table creation**, 10 GB per item collection.
- Streams retention 24 h. TTL deletes are background (typically within a few days) — filter expired items.

## Capacity modes
On-demand (pay per request; prices cut ~50% in Nov 2024; good default for new/spiky workloads;
configurable max throughput) vs Provisioned (+ auto scaling, reserved capacity) for steady, predictable
high throughput.

## Data modeling
1. List access patterns with frequency and latency needs.
2. Choose PK for high cardinality and even distribution; SK for range/sort/hierarchy
   (`ORDER#2026-10-01#123`).
3. **Single-table design**: multiple entity types share a table with overloaded keys (PK=`USER#1`,
   SK=`PROFILE` / `ORDER#…`) to fetch related items in one Query. Great for known patterns; harder for
   ad hoc and analytics. Multi-table is fine when patterns are independent.
4. GSIs for alternate access patterns (eventually consistent); sparse indexes for filtering;
   inverted index (GSI with PK=SK, SK=PK) for many-to-many.
5. Hot partitions: write sharding (`key#0..N` suffixes), caching (DAX), avoid low-cardinality keys
   (status, date).
6. Aggregations: maintain counters via Streams + Lambda or conditional updates; analytics via export to
   S3 / zero-ETL to Redshift/OpenSearch.

## Consistency & concurrency
Eventually consistent reads by default; strongly consistent reads on base table/LSI (not GSIs).
Optimistic locking with condition expressions on a version attribute. Idempotency via conditional
`attribute_not_exists(pk)`.

## Global tables
Multi-region, multi-active replication.
- **MREC** (default, multi-Region eventual consistency): async replication typically < 1 s; last-writer-wins on
  item timestamps; reads in one Region may not reflect writes elsewhere.
- **MRSC** (multi-Region strong consistency, GA 2025 — verified 2026-10): writes synchronously replicated to at
  least one other Region before success → **RPO = 0**; strongly consistent reads from any Region; conditional writes
  evaluate against the latest version. Must span **exactly 3 Regions**: 3 replicas, or 2 replicas + 1 **witness**
  (DynamoDB-managed, holds change data only). Create from an empty table. Available in 15 Regions incl. **Asia
  Pacific (Mumbai)**, Tokyo, Seoul, Osaka, Singapore, US, EU. Trade-off: write and strong-read latency include
  cross-Region RTT; concurrent cross-Region writes to the same item can conflict (handle errors/retries).
- Interview phrasing: "Payments ledger needing zero RPO across Regions → MRSC with Mumbai + Singapore replicas and a
  witness; accept higher write latency; MREC for everything else."

## Ecosystem
DAX (in-memory cache, microseconds, write-through), Streams (CDC → Lambda/Kinesis), Kinesis Data Streams
for DynamoDB, PITR (35 days), on-demand backup, export/import S3, zero-ETL integrations, PartiQL.

## Cost levers
On-demand vs provisioned break-even (~ steady utilization > ~30–40% often favors provisioned+AS ⚠️);
Standard-IA table class for infrequently accessed data; projections minimal on GSIs; avoid Scans;
TTL to expire data; compress large attributes.

## Gotchas
Scans in request path; filter expressions don't reduce consumed RCU; GSI throttling back-pressures base
table writes; LSIs cap item collections at 10 GB; hot keys; using DynamoDB for ad hoc analytics.

## Interview angles
Model "orders by customer sorted by date + orders by status" → PK=CUST#id, SK=ORDER#date#id; GSI1
PK=STATUS#x#shard, SK=date. Explain why no joins and how to evolve with new GSIs.

## Enterprise architect lens
- **Governance**: modeling reviews before table creation (access patterns doc required), naming/tagging
  standards, PITR + deletion protection mandatory in prod, on-demand by default with max-throughput caps, CMK for
  Confidential data, contributor insights for hot-key detection.
- **Multi-tenant**: tenant-prefixed partition keys + IAM `dynamodb:LeadingKeys` for pooled isolation;
  table-per-tenant for silo tier.
- **Analytics path**: never query DynamoDB for BI — zero-ETL to Redshift/OpenSearch, export to S3 (Iceberg) for
  the lakehouse; Streams → event backbone for integration.
- **Resilience tiers**: MREC global tables for most multi-Region apps; MRSC for zero-RPO ledgers; backups to a
  separate account with AWS Backup vault lock for ransomware protection.
