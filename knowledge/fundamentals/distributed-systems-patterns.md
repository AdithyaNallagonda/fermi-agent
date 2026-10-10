# Distributed Systems Patterns
Last reviewed: 2026-10 | Load when: consistency, transactions across services, replication, consensus

## Replication
| Type | How | Trade-off |
|---|---|---|
| Single-leader | Writes to leader, async/sync to followers | Simple; failover complexity; replica lag |
| Multi-leader | Writes in multiple regions | Conflict resolution needed (LWW, CRDTs, app merge) |
| Leaderless (Dynamo-style) | Quorum reads/writes, hinted handoff, read repair, anti-entropy (Merkle trees) | Tunable; eventual by default |
- Sync replication = durability + latency cost; semi-sync is a common middle ground.
- Replica lag anomalies: read-your-writes (route user to leader after write / version tokens),
  monotonic reads (sticky replica), consistent prefix.

## Consensus
- **Raft** (etcd, Consul, CockroachDB, Kafka KRaft) / **Paxos** (Spanner, Chubby): majority quorum of
  2f+1 nodes tolerates f failures. Used for leader election, config, metadata, replicated logs.
- Leader election with leases + **fencing tokens** to avoid split-brain zombie leaders.
- Clocks: wall clocks drift; use logical (Lamport), vector clocks, hybrid logical clocks (HLC), or
  bounded-uncertainty clocks (Spanner TrueTime, AWS Time Sync / ClockBound).

## Distributed transactions
- **2PC**: atomic across participants; blocking if coordinator fails; avoid across services.
- **Saga**: sequence of local transactions with **compensating actions**.
  - *Orchestration* (central coordinator: Step Functions, Temporal, Durable Functions) — explicit,
    easier to reason/monitor.
  - *Choreography* (events) — decoupled, harder to trace; good for few steps.
- **Transactional outbox**: write business row + outbox row in one local transaction; relay (CDC/
  poller) publishes to the broker → no dual-write inconsistency. Inbox/dedup table on consumer side.
- **Idempotency**: idempotency keys stored with result (TTL); natural idempotency via upserts,
  conditional writes (version/ETag), dedup IDs.

## Delivery semantics
At-most-once (fire & forget) / at-least-once (retries; consumers must be idempotent) / exactly-once
(= at-least-once + idempotent processing or transactional sinks, e.g., Kafka transactions, Flink
checkpoints with 2PC sinks). In interviews: "effectively-once via idempotent consumers."

## CQRS & Event Sourcing
- **CQRS**: separate write model from read models (projections in Redis/OpenSearch/DynamoDB). Use when
  read/write shapes or scale differ greatly. Cost: eventual consistency, more moving parts.
- **Event sourcing**: state = fold over immutable events; snapshots for speed; great audit/temporal
  queries; hard schema evolution (upcasters), GDPR erasure (crypto-shredding).

## Resilience patterns
Timeouts (always), retries with exponential backoff + jitter (cap attempts; retry budget), circuit
breaker, bulkhead, rate limiting/load shedding, back-pressure, fallback/graceful degradation, hedged
requests (tail latency), request coalescing, shuffle sharding, cell-based architecture.

## Coordination & misc
Distributed locks (Redis Redlock — contested; prefer DB/etcd/ZooKeeper leases with fencing; DynamoDB
conditional writes), leader-based scheduling, consistent hashing, gossip protocols (membership/failure
detection), Bloom filters, HyperLogLog (cardinality), Count-Min Sketch (heavy hitters), Merkle trees.

## Interview angles
- "Payment + inventory + shipping across services?" → Saga (orchestrated) + outbox + idempotency keys +
  compensations; explain failure at each step.
- "Exactly-once?" → explain it's an end-to-end property; dedup at sink.
- "Split brain?" → quorum + fencing tokens.
