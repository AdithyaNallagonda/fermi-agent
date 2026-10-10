# Reliability, Resilience & Disaster Recovery
Last reviewed: 2026-10 | Load when: availability targets, DR, multi-region, SRE

## SRE vocabulary
- **SLI**: measured indicator (e.g., % of requests < 300 ms and non-5xx).
- **SLO**: target for SLI over a window (99.9% over 28 days).
- **SLA**: contractual promise with penalties (set looser than SLO).
- **Error budget** = 1 − SLO. Burn-rate alerts (multi-window: e.g., 14.4× over 1 h and 6× over 6 h for
  a 30-day 99.9% SLO). Budget exhausted → freeze features, fix reliability.

## Availability building blocks
Multi-AZ by default (synchronous replication within region); health-checked load balancing; auto-healing
(ASG/K8s); stateless compute; managed multi-AZ databases; static stability (keep working when control
plane is down — pre-provision capacity, avoid dependency on control-plane APIs during failover).

## DR strategies (cost ↑, RTO/RPO ↓)
| Strategy | RPO | RTO | Notes |
|---|---|---|---|
| Backup & restore | Hours | Hours–day | Cross-region backups (AWS Backup, Azure Backup) |
| Pilot light | Minutes | 10s of min–hours | Data replicated, core infra off/minimal |
| Warm standby | Seconds–minutes | Minutes | Scaled-down full stack running |
| Multi-site active-active | Near zero | Near zero | Global data layer, conflict handling, highest cost |
Data replication options: Aurora Global Database (typ. < 1 s lag), DynamoDB Global Tables (eventual or
multi-region strong ⚠️), Cosmos DB multi-region writes, Spanner multi-region, Azure SQL failover groups,
S3 CRR (RTC 15-min SLA).

## Multi-region design concerns
Routing (Route 53 / Front Door / Global LB with health checks; ARC routing controls), data consistency
and conflict resolution, idempotency across regions, regional isolation (no cross-region sync calls in
the request path), failover runbooks + regular game days, DNS TTLs, capacity in the surviving region.

## Blast radius reduction
Cells (independent copies of the stack serving a subset of customers; cell router), shuffle sharding,
availability-zone independence, deployment waves (one AZ/cell → region → all), feature flags,
automatic rollback on alarms.

## Overload protection
Load shedding (reject early with 503/429), admission control, queue length limits, timeouts shorter
than caller's, retry budgets (≤ 10% extra load), circuit breakers, priority lanes.

## Chaos engineering
Hypothesis → small blast radius → measure → automate. Tools: AWS FIS, Azure Chaos Studio, Gremlin,
Chaos Mesh, Litmus.

## Backups
3-2-1 rule; immutable/air-gapped backups (vault lock) against ransomware; test restores regularly;
PITR for databases.

## Interview angles
"Design for 99.99%" → multi-AZ + no SPOF + automated failover + deployment safety; explain why 99.999%
typically needs multi-region active-active and what it costs.
