# Vector Databases & ANN Indexes
Last reviewed: 2026-10 ⚠️

## ANN index types
| Index | How | Trade-offs |
|---|---|---|
| Flat (exact) | Brute force | Perfect recall; O(n) — fine < ~100k vectors or with strong pre-filters |
| HNSW | Multi-layer proximity graph | Excellent recall/latency; memory heavy; params `M` (links, 16–64), `ef_construction` (build quality), `ef_search` (query recall vs latency) |
| IVF (IVFFlat/IVF-PQ) | Cluster centroids, search nearest lists (`nlist`, `nprobe`) | Less memory, needs training; recall depends on nprobe |
| PQ / SQ / binary quantization | Compress vectors | 4–32× memory savings; recall loss mitigated by re-scoring |
| DiskANN / Vamana | SSD-resident graph | Billions of vectors at lower cost |

## Distance metrics
Cosine (normalized vectors — most text embeddings), dot product, Euclidean (L2). Use what the embedding
model was trained for.

## Options
| Store | Notes | Choose when |
|---|---|---|
| pgvector (Postgres/Aurora/AlloyDB/Azure) | HNSW & IVFFlat; SQL joins + filters; pgvectorscale | Already on Postgres; < ~10–50M vectors; transactional consistency with app data |
| OpenSearch k-NN | Faiss/Lucene engines, hybrid search, filtering, disk-based mode | Need hybrid keyword+vector, large scale, existing OpenSearch |
| Azure AI Search | Vector + hybrid + semantic ranker, integrated vectorization | Azure RAG |
| Vertex AI Vector Search | ScaNN-based, very large scale | GCP |
| Amazon S3 Vectors (GA Dec 2025) | Serverless vector buckets; up to **2B vectors/index**, 10k indexes/bucket, dims 1–4,096, ~100 ms for frequent queries (< 1 s infrequent), top-K up to 10,000 with ≤100 results/page, 1,000 write req/s per index, 40 KB metadata (2 KB filterable), SSE-S3/KMS; up to ~90% cheaper than vector DBs | Billion-scale, cost-sensitive RAG; cold tier behind OpenSearch hot tier; Bedrock KB backend |
| Pinecone | Serverless managed vector DB, namespaces | Fast start, managed, multi-cloud |
| Weaviate / Qdrant / Milvus (Zilliz) | Open-source, rich filtering, hybrid | Self-host or managed; large scale (Milvus) |
| Redis / MemoryDB / Valkey vector | In-memory, lowest latency | Semantic caching, real-time recsys |
| MongoDB Atlas Vector Search / Cosmos DB vector | Inside document DB | Already on those DBs |
| Chroma / LanceDB / FAISS lib | Embedded/local | Prototypes, edge, offline |

## Sizing math
Memory for HNSW ≈ n × (d × bytes_per_dim + M × 2 × 4 bytes) × overhead. Example: 10M × 1024-dim float32 ≈
41 GB raw vectors + graph ~1–2 GB+ → plan ~50–60 GB RAM (before replicas). Quantization (int8 4×, binary
32×) drastically reduces this.

## Design considerations
Filtering strategy (pre-filter vs post-filter vs filtered HNSW), multi-tenancy (namespace/partition per
tenant vs metadata filter), hybrid search support, update/delete patterns (HNSW deletes are costly →
periodic rebuilds), backup/restore, consistency with source of truth, re-embedding migrations (dual
index + alias switch).

## Interview angles
"Why not just pgvector?" → scale, hybrid search needs, filtering performance, ops; "how to cut vector
DB cost 10×?" → quantization + disk-based indexes + dimension reduction (Matryoshka) + tiering.
