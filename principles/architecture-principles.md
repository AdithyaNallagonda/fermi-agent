# Architecture Principles

## Design tenets
- **Well-Architected lens on every design**: Operational Excellence, Security, Reliability,
  Performance Efficiency, Cost Optimization, Sustainability (AWS 6 pillars; Azure WAF 5 pillars;
  Google Cloud Architecture Framework). See `knowledge/cloud/well-architected-and-finops.md`.
- **Design for failure**: everything fails; define blast radius, timeouts, retries with jittered
  backoff, idempotency, circuit breakers, graceful degradation, and bulkheads.
- **Loose coupling, high cohesion**: bounded contexts, async messaging between domains, contracts
  versioned explicitly.
- **Stateless compute, stateful services**: push state into managed data stores; compute scales
  horizontally.
- **Data has gravity**: choose data stores per access pattern; minimize cross-region/cross-cloud data
  movement (latency + egress cost).
- **Evolutionary architecture**: start with a modular monolith unless team size/scaling/deploy
  independence demand microservices. Make decisions reversible where cheap (two-way doors).
- **Automate everything**: IaC, CI/CD, policy-as-code, tests, rollbacks.
- **Observability by design**: SLIs/SLOs defined with the design, OpenTelemetry instrumentation,
  correlation IDs end to end.
- **Cell-based / shuffle-sharded isolation** for large multi-tenant systems to cap blast radius.
- **Cost-aware**: provide a monthly cost estimate range and the top 3 cost drivers for each design.

## Decision heuristics
| Situation | Default |
|---|---|
| < 5 engineers, unclear domain | Modular monolith + managed DB |
| Spiky/unknown traffic | Serverless / autoscaling, on-demand capacity |
| Steady high throughput | Provisioned capacity + reservations/savings plans |
| Strong consistency + relational | PostgreSQL (Aurora/Azure Flexible/AlloyDB/Cloud SQL) |
| Massive key-value, predictable access | DynamoDB / Cosmos DB / Bigtable |
| Full-text, log analytics, hybrid search | OpenSearch |
| Sub-ms reads, ephemeral state | Redis/Valkey |
| Analytics over TBs–PBs | Columnar warehouse / lakehouse |
| Cross-service workflows | Orchestration (Step Functions/Durable Functions/Workflows) for business flows; choreography (events) for decoupled reactions |

## Anti-patterns to call out
Distributed monolith; shared database across services; synchronous chains > 3 hops; unbounded
retries; cache without TTL/invalidation plan; multi-region active-active without a conflict strategy;
"we'll add security later"; Kubernetes for a 3-endpoint CRUD app; premature sharding.
