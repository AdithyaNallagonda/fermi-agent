# Playbook: System Design (fundamentals → enterprise)

Knowledge: `knowledge/fundamentals/*` first, then cloud/db/search/messaging files as decided.
Template: `templates/design-doc.md`; decisions → `templates/adr.md`.

## Step 1 — Requirements (never skip)
- **Functional**: 3–7 core use cases (actor → action → outcome). Explicitly list out-of-scope.
- **Non-functional** (quantify): DAU/MAU, peak RPS (read/write split), payload sizes, latency SLO
  (p50/p99), availability (99.9% = 43.8 min/month; 99.99% = 4.38 min/month), durability, consistency
  needs per operation, RPO/RTO, data residency, compliance, budget, team skills, timeline.
- **Constraints**: existing cloud, licenses, on-prem integration, mandated tech.
- **Gate G1**: confirm requirements + NFR numbers with the user (batch ≤ 4 questions, recommended defaults);
  in interview-practice mode, play interviewer instead.

## Step 2 — Estimates (show arithmetic)
QPS = DAU × actions/day ÷ 86,400 × peak factor (2–10). Storage = writes/day × size × retention ×
replication. Bandwidth = QPS × payload. Cache size ≈ 20% of hot daily read set (80/20).
See `knowledge/fundamentals/system-design-fundamentals.md` for latency numbers and cheat sheet.

## Step 3 — API & data model
- API style per client (REST/gRPC/GraphQL/WebSocket); key endpoints with idempotency keys, pagination.
- Entities + **access patterns** → store choice via `knowledge/databases/database-selection.md`.
- Partition/shard keys, indexes, TTLs.

## Step 4 — High-level design
Mermaid diagram: clients → edge (DNS, CDN, WAF) → LB/API gateway → services → caches → data stores →
async (queues/streams) → analytics/search → observability. Walk one read and one write path.

## Step 5 — Deep dives (pick 2–4 that matter most)
Hot partitions, fan-out, consistency/transactions (saga/outbox), caching & invalidation, search
indexing pipeline, rate limiting, multi-region, idempotency/exactly-once, ordering, backpressure.

## Step 6 — Cross-cutting
- Security (identity, network, data, secrets, threat highlights) — `principles/security-principles.md`
- Reliability: SPOFs, failover, DR strategy (backup/restore, pilot light, warm standby, active-active)
- Observability: SLIs/SLOs, golden signals, tracing
- Cost: monthly estimate range, top 3 drivers, optimization levers
- Operations: deployment strategy, IaC, runbooks

## Step 7 — Trade-offs & evolution
**Gate G2** for one-way-door choices (primary datastore, cloud/platform, isolation model, multi-region).
Table of alternatives considered and why rejected. What breaks first at 10×, and the next step.

> **Audit checkpoint (B + E) — before writing deliverables:** every choice steelmanned against alternatives,
> NFRs met with numbers, no maintenance/EOL services, volatile facts verified or flagged.

## Step 8 — Deliverables
Write the design doc + ADR drafts to this ask's `.docs/` folder (chat: TL;DR + links). Offer: IaC skeleton
(Terraform/CDK/Bicep) and backlog of epics (`templates/epic-feature-story.md`); product files go to the project after G4.

## Enterprise extras (when org-scale)
Load `knowledge/enterprise/*` as needed — landing zones, multi-tenant SaaS, integration, data governance,
regulatory architecture, platform engineering. For portfolio-level work switch to `enterprise-architecture.md`.
Check `knowledge/cloud/aws.md` service-lifecycle table so you never recommend services in maintenance/sunset.
Landing zone & account/subscription strategy, network topology (hub-spoke/TGW/vWAN), identity
federation, shared services, platform engineering (IDP, golden paths), governance (SCPs/Azure
Policy/Org Policy), FinOps tagging, data mesh/governance, integration (API management, ESB → events),
migration strategy (7 Rs).

## Final step — Adversarial audit (mandatory)
Follow `instructions/adversarial-audit.md` as the senior reviewer of this work. Tier: **Standard (Deep for production/regulated)**.
Apply: B (every technology/pattern choice), A (rollout/migration plan), E (limits, prices, service status), D (any IaC/code/diagram produced). Fix Blockers before presenting; end with the 🔍 audit summary
(`principles/adversarial-self-audit.md`).
