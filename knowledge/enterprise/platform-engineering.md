# Platform Engineering & Team Topologies
Last reviewed: 2026-10 | Sources: CNCF TAG App Delivery platforms whitepaper & Platform Engineering Maturity
Model; Team Topologies (Skelton & Pais). Load when: IDPs, golden paths, platform teams, DevEx, org design.

## Why
Reduce developer cognitive load and standardize secure, compliant delivery by offering **self-service
capabilities as a product** (the Internal Developer Platform), instead of tickets to central ops.

## Team Topologies
- Team types: **stream-aligned** (owns a value stream end to end) · **platform** (provides internal services as a
  product) · **enabling** (coaches, temporary) · **complicated-subsystem** (deep specialist component).
- Interaction modes: **collaboration** (time-boxed), **X-as-a-Service** (default for platform), **facilitating**.
- Design for fast flow; team cognitive load as a first-class constraint; Conway's Law (inverse Conway maneuver).

## IDP building blocks
| Capability | Examples |
|---|---|
| Developer portal / catalog | Backstage, Port, Cortex, OpsLevel (service catalog, ownership, docs, scorecards) |
| Golden paths / templates | Backstage software templates, cookiecutters, IaC modules (Terraform, CDK, Bicep AVM) |
| Infra self-service | Crossplane, Terraform modules via PR/automation, AWS Service Catalog, Azure Deployment Environments |
| CI/CD | GitHub Actions/GitLab reusable workflows with built-in security scans (SAST/SCA/IaC/secrets) |
| Runtime | Kubernetes (EKS/AKS/GKE) with Gateway API, or serverless platforms (Lambda/Container Apps/Cloud Run) |
| Observability | OTel by default, dashboards and SLO templates per service |
| Security & compliance | Policy-as-code, signed artifacts, SBOMs, secret management, scorecards |
| AI | Approved model gateway, RAG/agent templates, eval harness, MCP tool registry |

## CNCF Platform Engineering Maturity Model
Levels: **Provisional → Operational → Scalable → Optimizing**, assessed per aspect (not the org as a whole):
**Investment** (how funded/staffed), **Adoption** (why/how users adopt — mandated → intrinsic pull),
**Interfaces** (custom processes → standard tooling → self-service → integrated services), **Operations** (by
request → centrally tracked → centrally enabled → managed services), **Measurement** (ad hoc → consistent
collection → insights → quantitative & qualitative). Use as a diagnostic, then pick the next step per aspect.

## Platform as a product
Product manager for the platform; user research with developers; roadmap; SLAs/SLOs for platform services;
versioned, documented APIs; deprecation policies; adoption via value not mandate (but guardrails can be
mandatory).

## Metrics
DORA (deployment frequency, lead time, change failure rate, recovery time), SPACE/DevEx (satisfaction, flow,
cognitive load), onboarding time to first deploy, % services on golden paths, time to provision environment,
platform NPS, cost per environment, security findings MTTR on paved vs non-paved.

## Anti-patterns
"Platform" = rebranded ops ticket queue; building everything bespoke instead of composing managed services;
mandating without solving pain; ignoring the long tail (legacy apps); Kubernetes-for-everything; no product
owner; measuring outputs (tools shipped) not outcomes.

## Interview angles
"Your 40 teams deploy inconsistently and security findings pile up — what do you do?" → stream-aligned teams +
platform team; golden path with security baked in; Backstage catalog + scorecards; measure DORA and MTTR;
adopt via pilot teams; maturity model to plan next steps.
