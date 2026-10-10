# System Design Fundamentals
Last reviewed: 2026-10 | Load when: any design, interview, or estimation task

## Mental model
A system is a pipeline of **requests through resources**. Every design is about where you put state,
how you scale reads vs writes, and what you trade between latency, consistency, availability, and cost.

## Latency numbers (order of magnitude)
| Operation | Time |
|---|---|
| L1 cache ref | ~1 ns |
| Main memory ref | ~100 ns |
| Compress 1 KB (fast codec) | ~2–3 µs |
| Read 1 MB sequentially from memory | ~10–50 µs |
| NVMe SSD random read | ~20–100 µs |
| Round trip within same AZ | ~0.1–0.5 ms |
| Redis GET (same AZ, network incl.) | ~0.2–1 ms |
| Read 1 MB from SSD | ~0.2–1 ms |
| Cross-AZ round trip | ~1–2 ms |
| Typical indexed DB point query | ~1–5 ms |
| Cross-region (US East ↔ West) | ~60–70 ms |
| Mumbai ↔ US East | ~180–220 ms |
| HDD seek | ~5–10 ms |

## Estimation cheat sheet
- 1 day = 86,400 s ≈ 10⁵ s. 1M requests/day ≈ 12 RPS avg. Peak = avg × 2–10.
- 1 char ≈ 1 byte (ASCII), UTF-8 up to 4. UUID 16 bytes binary / 36 chars text.
- Powers: 2¹⁰ ≈ 10³ (KB), 2²⁰ ≈ 10⁶ (MB), 2³⁰ ≈ 10⁹ (GB), 2⁴⁰ ≈ 10¹² (TB).
- Availability: 99.9% → 8.76 h/yr; 99.95% → 4.38 h/yr; 99.99% → 52.6 min/yr; 99.999% → 5.26 min/yr.
- Serial dependencies multiply availability: 0.999 × 0.999 = 0.998. Parallel redundancy: 1 − (1−a)ⁿ.
- Little's Law: concurrency = throughput × latency (1,000 RPS × 0.2 s = 200 in-flight requests).
- A single modern app server: ~1–10k RPS for simple handlers; a single Postgres primary: ~10–50k simple
  TPS on large hardware; Redis node: ~100k+ ops/s; Kafka partition: ~10s of MB/s.

## Scalability
- **Vertical** (bigger box) — simple, limited, SPOF. **Horizontal** (more boxes) — needs statelessness,
  load balancing, partitioning.
- **Read scaling**: caching → read replicas → CQRS read models → CDN/edge.
- **Write scaling**: batching, async queues, partitioning/sharding, write-optimized stores (LSM).
- **Stateless services**: sessions in Redis/JWT; files in object storage.

## Load balancing
- L4 (TCP/UDP, NLB) vs L7 (HTTP, ALB/App Gateway/Envoy): L7 can route by path/header, terminate TLS,
  do retries; L4 is faster, preserves client IP, handles non-HTTP.
- Algorithms: round robin, least connections, least outstanding requests, weighted, consistent hashing
  (sticky to shard/cache), power of two choices.
- Health checks (shallow vs deep — deep checks can cascade failures), connection draining, slow start.

## CAP & PACELC
- **CAP**: during a network **P**artition choose **C**onsistency or **A**vailability. Partitions are not
  optional, so the real choice is CP vs AP *during failure*.
- **PACELC**: if Partition → A or C; **E**lse → **L**atency or **C**onsistency. DynamoDB (default) = PA/EL;
  Spanner = PC/EC; Cassandra = PA/EL (tunable); Cosmos DB tunable per consistency level.

## Consistency models (strong → weak)
Linearizable → sequential → causal → read-your-writes / monotonic reads → bounded staleness →
eventual. Quorums: R + W > N gives strong reads on Dynamo-style stores (e.g., N=3, W=2, R=2).

## Storage engines
- **B-tree** (Postgres, MySQL InnoDB, SQL Server): read-optimized, in-place updates.
- **LSM-tree** (Cassandra, RocksDB, DynamoDB internals, ScyllaDB): write-optimized, compaction,
  bloom filters; read/space amplification trade-offs.
- **Columnar** (Redshift, BigQuery, Parquet): scan/aggregate-optimized, compression, vectorized.

## Partitioning (sharding)
Range (good for scans, hotspot risk), hash (even, no range scans), consistent hashing with virtual
nodes (minimal movement on rebalance), directory-based (flexible, extra lookup). Choose a high-
cardinality key aligned to access patterns; plan for hot keys (write sharding/salting, caching).

## Interview angles
- "How do you scale X?" → find the bottleneck (CPU, memory, I/O, network, lock contention) first.
- Always discuss: hot keys, thundering herd, back-pressure, idempotent retries, data growth.
- Phrase: "Given p99 < 100 ms and 50k RPS reads, I'll front the DB with a read-through cache; eventual
  consistency of up to 5 s is acceptable per requirements."

## References
Designing Data-Intensive Applications (Kleppmann); AWS Builders' Library; Google SRE book.
