# OpenSearch (and Elasticsearch)
Last reviewed: 2026-10 — OpenSearch **3.9** (Sep 2026) latest; 3.x line = Lucene 10, Java 21+, gRPC transport,
pull-based ingestion, reader/writer separation, GPU-accelerated vector indexing, agentic search ⚠️ verify feature GA
per release. OpenSearch Software Foundation (Linux Foundation) since Sep 2024. Amazon OpenSearch Service lags OSS
releases — check supported versions via `aws-docs`.

## Mental model
Distributed search & analytics engine on Apache Lucene. Index → primary shards (each a Lucene index of
immutable **segments**) + replica shards. Inverted index for text, BKD trees for numerics/geo, doc values
(columnar) for sorting/aggregations, HNSW/IVF graphs for vectors. Near-real-time: documents become
searchable after **refresh** (default 1 s).

## Node roles
Cluster manager (dedicated, 3 for quorum), data (hot/warm), ingest, coordinating, ML, search (for
search replicas / reader-writer separation ⚠️). AWS: dedicated master nodes, UltraWarm (S3-backed read-
only warm), cold storage, **OR1/OR2/OM2 instances** (segment replication with S3 durability ⚠️ verify).

## Sizing rules of thumb (⚠️ guidance, validate with load tests)
- Shard size: **10–30 GB** for search-latency-sensitive, **30–50 GB** for logs/time-series.
- Shards per node: keep total shards ≤ ~25 per GiB of JVM heap; AWS caps ~1,000 shards per node (2.x+).
- JVM heap = 50% of RAM, ≤ ~31–32 GB (compressed oops); rest for OS page cache (Lucene relies on it).
- Storage: source × (1 + replicas) × 1.45 overhead (indexing overhead + OS reserve + free space).
- Primary shard count is fixed at index creation (use rollover / split / shrink / reindex to change).
- Replicas ≥ 1 for HA; 3 AZs with zone awareness for production.

## Index design
- Explicit **mappings** (avoid dynamic mapping explosions; set `dynamic: strict` or templates). `text`
  (analyzed) vs `keyword` (exact, aggregations); multi-fields (`title` + `title.keyword`).
- Analyzers: tokenizer + filters (lowercase, stemming, synonyms, edge n-grams for autocomplete, ICU for
  Indic languages).
- Index templates + component templates; aliases for zero-downtime reindex (`products` → `products_v2`).
- Time-series: data streams / rollover by size/age + **ISM** (Index State Management) policies: hot →
  warm (UltraWarm) → cold → delete.
- Denormalize; joins limited (nested, parent-join are costly).

## Query & relevance
BM25 default. `bool` query (must/should/filter/must_not) — **filters are cached and don't score**.
Boosting, `function_score`, decay functions, rescoring, Learning to Rank plugin, synonyms, search
templates, suggesters/completion for autocomplete, highlighting. Pagination: `search_after` + PIT (point
in time) instead of deep `from/size` (max_result_window 10k).

## Vector, semantic & hybrid search
- **k-NN plugin**: engines **Faiss** (HNSW, IVF; PQ/SQ quantization; GPU-accelerated indexing ⚠️),
  **Lucene** (HNSW, efficient filtering); nmslib deprecated. Params: `m`, `ef_construction`,
  `ef_search`. Disk-based vector search (`on_disk` mode with binary quantization) for cost.
- Exact k-NN via script score for small filtered sets; approximate k-NN for scale; efficient filtering.
- **Neural search** plugin + ML Commons: ingest pipelines that call embedding models (local or remote
  connectors to Bedrock/SageMaker/OpenAI/Cohere); `neural` query; sparse neural (learned sparse).
- **Hybrid search**: `hybrid` query + search pipeline with normalization processor (min-max / L2) and
  combination (arithmetic/geometric/harmonic mean) or **RRF** ⚠️ version; reranking processors
  (cross-encoders).
- Conversational search / RAG processors, agent framework in ML Commons ⚠️.

## Ingestion
Bulk API (5–15 MB per request; parallel workers), refresh_interval 30 s+ or `-1` during bulk loads,
replicas 0 during initial load then re-enable, ingest pipelines (grok, date, enrich), **OpenSearch
Ingestion** (managed Data Prepper pipelines), zero-ETL from DynamoDB/S3/DocumentDB, Logstash/Fluent Bit,
CDC from databases via Debezium/Kafka connectors.

## Amazon OpenSearch Serverless
Collections (search, time series, vector search), compute in OCUs (separate indexing & search),
encryption/network/data access policies. Trade-offs: no shard tuning, some API/plugin limitations,
minimum OCU cost ⚠️ verify.

## Security
Fine-grained access control (index/document/field-level security), SAML/OIDC/Cognito for Dashboards,
IAM, VPC domains, encryption at rest/in transit, audit logs, multi-tenancy in Dashboards.

## Performance tuning checklist
Search: filters over queries, avoid leading wildcards/regex, limit `size`, reduce shards per query,
routing by tenant, `preference` for cache locality, force-merge read-only indices, request/query caches,
warmers via index sorting. Indexing: bulk sizing, refresh interval, translog durability `async` (risk),
fewer replicas during load, avoid mapping explosions, segment replication.

## Observability
Cluster health (green/yellow/red), JVM memory pressure (> 80% danger), CPU, thread pool rejections
(write/search), circuit breakers, shard skew, slow logs, `_cat/shards`, `_nodes/stats`, Performance
Analyzer, Query Insights (top N queries).

## Gotchas
Oversharding (many tiny shards) is the #1 problem; yellow status due to replicas on single node;
mapping explosion; deep pagination; using OpenSearch as primary system of record (keep source of truth
elsewhere; reindex from it); split-brain on 2 masters (always 3).

## OpenSearch vs Elasticsearch
Fork of ES 7.10.2 (2021, after Elastic license change; Elastic later added AGPL option in 2024).
Diverged: ES has ES|QL, ELSER, semantic_text; OpenSearch has neural/hybrid plugins, Apache 2.0 license,
AWS managed service. Client libraries are no longer fully interchangeable.

## Interview angles
Design e-commerce search: CDC indexing, analyzers, facets (terms aggs on keyword), relevance boosts
(popularity, margin), autocomplete (edge n-gram / completion), hybrid semantic search, multi-language,
zero-downtime reindex via aliases. Log analytics at 5 TB/day: data streams, rollover, ISM tiers, shard
sizing math.

## Enterprise architect lens
- **Search as a platform**: one platform team runs domains/collections for many product teams — standard index
  templates, ISM policies, analyzers (incl. Indic language analyzers), FGAC roles, cost showback per index pattern.
- **Topology choices**: separate clusters per workload class (log analytics vs customer-facing search vs vector/RAG)
  — different SLOs, scaling and cost profiles; cross-cluster search for federated queries; cross-cluster replication
  for DR/geo read locality (active-passive); OpenSearch Serverless for spiky/low-ops collections.
- **Multi-tenancy**: index-per-tenant (strong isolation, shard explosion risk) vs shared index with routing +
  filtered aliases + document-level security (efficient) vs cluster-per-tier for enterprise tenants.
- **Log analytics at scale**: OpenSearch Ingestion pipelines, data streams + rollover + ISM hot→UltraWarm→cold,
  or tier to S3 + Athena/Security Lake; consider zero-ETL direct query on S3 for rarely-queried logs.
- **Vector at scale**: hot tier in OpenSearch (HNSW, quantization, disk-based mode) + cold tier in **S3 Vectors**;
  hybrid search + rerank; ACL filters at query time.
- **Governance**: mapping change reviews, relevance test suites (judgment lists, nDCG) in CI, query budgets,
  slow-log review, version upgrade cadence (Amazon OpenSearch Service lags OSS — plan blue/green upgrades).
