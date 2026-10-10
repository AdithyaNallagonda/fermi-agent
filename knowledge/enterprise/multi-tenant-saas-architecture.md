# Multi-Tenant SaaS Architecture
Last reviewed: 2026-10 | Sources: AWS SaaS Architecture Fundamentals & SaaS Tenant Isolation Strategies
whitepapers, AWS Well-Architected SaaS Lens, Azure Architecture Center multitenancy guidance.
Load when: building B2B SaaS, multi-tenant platforms, tenant isolation, SaaS interviews, monetization tiers.

## Control plane vs application plane
- **Control plane** (not itself multi-tenant; global to all tenants): onboarding, tenant management, identity,
  tiering, metering & billing, admin console, tenant-aware analytics/operations, deployment orchestration.
- **Application plane**: the multi-tenant product — where tenant context, isolation, data partitioning and
  noisy-neighbor controls live.

## Deployment / isolation models
| Model | What | Pros | Cons | Typical use |
|---|---|---|---|---|
| **Silo** | Dedicated resources per tenant (account/subscription, VPC, cluster, DB) | Strongest isolation, per-tenant cost & compliance, no noisy neighbors | Cost, operational sprawl, slower onboarding | Enterprise/regulated tier |
| **Pool** | Shared resources; tenant isolation enforced in code/policy | Cost efficiency, agility, easy upgrades | Noisy neighbors, harder isolation proof, per-tenant cost attribution | SMB/basic tiers |
| **Bridge** (mixed) | Mix per layer/service (e.g., shared web tier, siloed DB) | Optimize per microservice | Complexity | Most real systems |
| **Cell-based** | Pools of tenants per cell (stamp) | Blast-radius control, scale-out | Cell router, placement, migrations | Large SaaS |
Tiering drives isolation: Basic → pooled; Premium → pooled with dedicated capacity; Enterprise → silo/cell.

## Tenant context & identity
- Tenant ID bound to identity at sign-in (custom claim in JWT: `tenant_id`, `tier`, roles) — never trust a
  tenant ID from the request body/URL alone.
- Propagate tenant context through every call, log line, metric and trace (baggage).
- Tenant-aware authorization (RBAC/ABAC/ReBAC) at API and data layers.

## Enforcing isolation (defense in depth)
| Layer | Pool-model enforcement |
|---|---|
| API | Gateway validates token; per-tenant throttling/quotas |
| Compute | Scoped credentials per request: **token vending machine** / dynamically generated IAM session policies (AWS `aws:PrincipalTag`/session tags limiting to `tenant_id`-prefixed keys) |
| Data — relational | Shared schema + `tenant_id` + **row-level security** (Postgres RLS / SQL Server RLS); schema-per-tenant; DB-per-tenant for silo |
| Data — NoSQL | Partition key prefixed with tenant (`TENANT#123#…`) + IAM `dynamodb:LeadingKeys` condition; Cosmos hierarchical partition keys |
| Object storage | Prefix-per-tenant + IAM conditions; bucket-per-tenant for silo; per-tenant KMS keys for crypto isolation |
| Search/vector | Index-per-tenant (silo) or filtered aliases/routing + document-level security; never rely on prompt-level filtering for RAG |
| Encryption | Per-tenant keys (BYOK/CMK for enterprise tier) enabling crypto-shredding on offboarding |
Test isolation continuously (automated cross-tenant access tests in CI).

## Noisy neighbor controls
Per-tenant rate limits and quotas (usage plans), fair-share queues (per-tenant SQS/partitions, weighted
scheduling), compute bulkheads per tier, DB connection pools per tier, cell placement for heavy tenants,
autoscaling on tenant-aware metrics, sharding big tenants out.

## Onboarding & lifecycle
Automated, idempotent onboarding workflow (Step Functions/Durable Functions): create tenant record → identity
setup (pool/user group or IdP federation) → provision tier resources (silo IaC) → configure billing → seed data
→ notify. Offboarding: export, delete, crypto-shred, retain audit. Tenant migration between tiers/cells.

## Metering, billing & cost per tenant
Emit usage events (API calls, storage, tokens, compute seconds) with tenant ID → metering pipeline → billing
system (Stripe/Chargebee/Orb/Metronome/AWS Marketplace). **Cost per tenant**: tag silo resources; apportion
pooled costs using consumption metrics → informs pricing and margin per tier (see
`business/saas-monetization-and-pricing.md`).

## Operations
Tenant-aware dashboards (top tenants by load/errors/cost), per-tenant SLOs for enterprise tier, tenant-aware
deployments (canary to internal → low-tier → enterprise; per-cell waves), feature flags per tenant/tier,
support tooling with impersonation under audit.

## Multi-tenant AI/agents
Per-tenant RAG indexes or strict ACL filtering at retrieval, per-tenant token quotas & budgets, tenant-scoped
agent memory namespaces (e.g., AgentCore Memory keyed on actorId/tenant), per-tenant model/config, prompt
injection isolation (one tenant's documents never in another's context), cost attribution per tenant.

## Interview angles
"Design a multi-tenant SaaS for 10k SMBs + 50 enterprises" → control vs app plane, pooled cells for SMB, silo for
enterprise, tenant context in JWT, RLS + scoped credentials, per-tenant throttling, metering, onboarding
automation, cost per tenant, tiered deployment waves.
