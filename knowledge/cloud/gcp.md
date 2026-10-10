# Google Cloud — Core Services & Selection
Last reviewed: 2026-10 ⚠️ verify on cloud.google.com docs

## Structure
Organization → Folders → Projects → Resources. IAM inherited down the hierarchy; Organization Policy
constraints. Regions/zones (India: asia-south1 Mumbai, asia-south2 Delhi). **Global VPC** (subnets are
regional, network is global) — key differentiator.

## Compute selection
| Service | Use when |
|---|---|
| Cloud Run (services, jobs, functions) | Default for containers/serverless HTTP; scale to zero; GPUs available |
| Cloud Run functions (formerly Cloud Functions) | Event-driven functions |
| GKE (Standard / Autopilot) | Kubernetes; Autopilot = per-pod billing, Google-managed nodes |
| Compute Engine (+ MIGs) | VMs, custom machine types, Spot VMs, sole tenancy |
| App Engine | Legacy PaaS; prefer Cloud Run for new work |
| Batch | Batch jobs |

## Storage & databases
Cloud Storage (Standard/Nearline/Coldline/Archive; dual/multi-region; Autoclass), Persistent Disk/
Hyperdisk, Filestore. Cloud SQL (MySQL/PostgreSQL/SQL Server), AlloyDB (PostgreSQL-compatible, columnar
engine, AI), Spanner (global, strongly consistent, also graph/full-text/vector), Bigtable (wide-column),
Firestore (document, serverless), Memorystore (Redis/Valkey/Memcached), BigQuery (serverless warehouse).

## Integration & data
Pub/Sub (global messaging; BigQuery/Cloud Storage subscriptions), Eventarc, Workflows, Cloud Tasks,
Cloud Scheduler, Dataflow (Apache Beam batch/stream), Dataproc (Spark/Hadoop; Serverless for Spark),
Datastream (CDC), Cloud Composer (Airflow), Dataplex (governance), Looker.

## Networking (see `networking/gcp-networking.md`)
Global external Application LB (anycast single IP), Cloud CDN, Cloud Armor, Cloud NAT, Private Service
Connect, Shared VPC, VPC peering, Network Connectivity Center, Cloud Interconnect, Cloud VPN (HA VPN),
Cloud DNS.

## Security
Cloud IAM (roles, conditions, Workload Identity Federation), VPC Service Controls (data exfiltration
perimeters), Cloud KMS/HSM/EKM, Secret Manager, Security Command Center, BeyondCorp/Chrome Enterprise
Premium (zero trust), Binary Authorization, Assured Workloads.

## AI
**Gemini Enterprise Agent Platform** (announced Cloud Next, 22 Apr 2026 — rebrands and consolidates **Vertex AI**;
all Vertex AI services now ship under it): Model Garden (200+ models incl. Gemini and Claude), ADK (code-first),
Agent Studio (low-code), Agent Engine (managed runtime + memory), Vector Search, Feature Store, Pipelines,
evaluation, governance. **Gemini Enterprise** = workforce agent app (formerly Agentspace). Document AI, TPUs.
Docs/exams may still say "Vertex AI" during transition.

## Cost levers
Sustained use discounts (automatic, some VM families), committed use discounts (resource- and spend-
based), Spot VMs, BigQuery editions/slot reservations vs on-demand, Autoclass, recommender.

## Exam/interview traps
PCA favors managed/serverless and Google-recommended practices; know when Spanner vs Cloud SQL vs
Bigtable vs Firestore; VPC Service Controls for exfiltration; Shared VPC for central network admin;
BigQuery partitioning + clustering for cost.

## Enterprise architect lens
Enterprise foundations blueprint (folders per environment, Shared VPC, org policies incl. resource-location
restriction to asia-south1/asia-south2 for residency, central log sinks, SCC, VPC Service Controls) — see
`enterprise/landing-zones-and-cloud-governance.md`; BigQuery as the analytics backbone with editions/reservations
governed centrally; Gemini Enterprise Agent Platform behind VPC-SC with Model Armor; committed use discounts at
billing-account level; GCP often chosen for data/AI workloads in multi-cloud estates — integrate identity (Workforce
Identity Federation) and network (Cross-Cloud Interconnect) deliberately.
