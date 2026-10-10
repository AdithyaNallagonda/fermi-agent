# Microservices & Domain-Driven Design
Last reviewed: 2026-10 | Load when: service boundaries, decomposition, monolith migration

## Monolith vs modular monolith vs microservices
| | Monolith | Modular monolith | Microservices |
|---|---|---|---|
| Team size | 1–2 teams | 2–6 teams | Many autonomous teams |
| Deploy | Single | Single, modules enforced | Independent |
| Ops overhead | Low | Low | High (observability, networking, data consistency) |
| When | Early product | Default for most new systems | Clear bounded contexts, independent scaling/release needs |
Microservices are an **organizational scaling** tool first (Conway's Law), a technical one second.

## DDD toolkit
- **Strategic**: domains (core / supporting / generic), **bounded contexts**, ubiquitous language,
  context maps (shared kernel, customer-supplier, conformist, anti-corruption layer, open host).
- **Tactical**: entities, value objects, aggregates (consistency boundary — one transaction per
  aggregate), domain events, repositories, domain services.
- **Discovery**: Event Storming (domain events → commands → aggregates → bounded contexts).

## Service boundaries heuristics
Align with bounded contexts and team ownership; own your data (no shared DB); high cohesion; minimize
synchronous coupling; split by rate of change and scaling profile; avoid "entity services" (CRUD-per-
table = distributed monolith).

## Communication
Sync (REST/gRPC) for queries needing immediate answer; async events for state propagation. Limit call
chain depth. API composition or CQRS read models for cross-service queries.

## Data management
Database-per-service; sagas for cross-service workflows; outbox for events; data replication via events
for local read copies; reporting via a data platform (not by querying service DBs).

## Platform concerns
Service discovery, API gateway, service mesh (Istio/Linkerd/App Mesh is deprecated → use VPC Lattice or
ECS Service Connect on AWS ⚠️), mTLS, centralized observability with trace propagation (W3C
traceparent), config/secrets, CI/CD per service, contract testing, golden-path templates (IDP:
Backstage).

## Migration: Strangler Fig
1. Put a façade/proxy in front of the monolith. 2. Carve one bounded context (start with an edge,
low-risk, high-value). 3. Route traffic gradually; sync data via CDC/ACL. 4. Retire the old code path.
Repeat. Use branch-by-abstraction inside the code; feature flags for cutover.

## Anti-patterns
Distributed monolith (lockstep deploys), shared libraries with business logic, chatty services, nano-
services, synchronous saga chains, no ownership.

## Interview angles
"How would you break this monolith?" → Event Storming → bounded contexts → strangler, start with
least-coupled context; data separation strategy; measure (DORA metrics) to prove value.
