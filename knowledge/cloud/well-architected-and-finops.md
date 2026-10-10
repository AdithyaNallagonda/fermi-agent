# Well-Architected, Landing Zones, Migration & FinOps
Last reviewed: 2026-10

## Well-Architected frameworks
| AWS (6 pillars) | Azure WAF (5 pillars) | Google Cloud Architecture Framework |
|---|---|---|
| Operational Excellence | Operational Excellence | Operational excellence |
| Security | Security | Security, privacy, compliance |
| Reliability | Reliability | Reliability |
| Performance Efficiency | Performance Efficiency | Performance optimization |
| Cost Optimization | Cost Optimization | Cost optimization |
| Sustainability | (guidance in sustainability workloads) | Sustainability |
AWS also has Lenses (Serverless, SaaS, Data Analytics, ML, GenAI, Financial Services…) and the
Well-Architected Tool.

## Landing zones (enterprise foundation)
Multi-account/subscription/project structure by environment and workload; centralized identity (SSO
with IdP), log archive and security tooling accounts, network hub (shared egress/inspection, DNS),
guardrails (SCPs/Azure Policy/Org Policy), tagging standards, account vending (Control Tower AFT,
Azure subscription vending, GCP project factory), budgets per account.

## Migration — 7 Rs
Retire, Retain, Rehost (lift & shift), Relocate (e.g., VMware Cloud), Replatform (lift & reshape, e.g.,
to RDS), Repurchase (SaaS), Refactor/Re-architect. Phases: Assess (discovery, TCO, portfolio) →
Mobilize (landing zone, pilot, skills) → Migrate & Modernize (waves). Tools: AWS Transform/Application
Migration Service/DMS, Azure Migrate/DMS, Google Migration Center.

## FinOps (FinOps Foundation framework)
Phases: **Inform** (visibility, allocation, tagging, showback/chargeback) → **Optimize** (rightsizing,
commitments, Spot, storage tiers, architecture) → **Operate** (governance, budgets, anomaly alerts,
unit economics). Track **unit cost** (cost per order/tenant/1k requests), commitment coverage &
utilization, waste %. FOCUS spec for normalized billing data across clouds.

## Top cost traps
NAT Gateway data processing; cross-AZ/region transfer; internet egress; idle resources (dev envs
running 24×7 — schedule them); overprovisioned DBs; unbounded logs/metrics cardinality; gp2→gp3 not
migrated; snapshots never deleted; provisioned throughput/GPU idle; premium support tiers; LLM token
spend without caching/routing.

## Sustainability
Region choice (carbon intensity), Graviton/ARM, right-size, serverless/scale-to-zero, data lifecycle,
efficient code. Customer Carbon Footprint tool / Emissions Impact Dashboard / Carbon Footprint (GCP).
