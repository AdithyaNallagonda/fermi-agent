# Multi-Environment & Production Deployment
Last reviewed: 2026-10 | Load when: environment strategy, promotion flow, go-live/cutover, rollback design,
release runbooks. Strategies overview: `devops/cicd-and-release.md`. Reliability: `fundamentals/reliability-and-resilience.md`.

## Environment topology
| Environment | Purpose | Notes |
|---|---|---|
| Local / preview (ephemeral) | Per-PR feedback | Created and destroyed by the pipeline; seeded test data |
| Dev / integration | Continuous integration of main | Auto-deploy on merge |
| Test / QA / UAT | Functional, contract, user acceptance | Stable data sets; masked data only |
| Staging / pre-prod | Production-like rehearsal: performance, DAST, migration dry runs | Same topology and IaC as prod, smaller scale; same deploy path |
| Production (+ DR region) | Live traffic | Progressive rollout, strict access, full observability |
Isolation: separate cloud accounts/subscriptions/projects, networks, identities and secrets per environment;
production access is just-in-time and audited. Parity: same artifacts, same IaC modules, same pipeline; only
declared configuration differs (sizes, counts, endpoints, flags).

## Configuration & secrets
Config separated from the artifact (12-factor); one schema, per-environment values in version control (non-secret)
and a vault (secret); validate config at startup and in the pipeline; no environment-specific branches; feature
flags for behaviour differences, with an owner and removal date.

## Promotion flow
`build once` → deploy to dev → automated tests → promote **the same digest** to staging → verification →
approval → production in waves. Each promotion carries evidence: test results, scan results, the change list,
the infrastructure plan, and who approved. Infrastructure changes promote the same way (module version → plan →
apply per environment).

## Ordering a release
1. **Infrastructure** changes that are backward compatible (new resources, capacity).
2. **Data/schema — expand** (add columns/tables/indexes; no breaking changes).
3. **Application** (new version tolerant of old and new schema), behind flags where possible.
4. **Configuration / flags** flipped progressively.
5. **Traffic** shifted (canary → full) with health gates.
6. **Data/schema — contract** (remove old structures) in a later release, after the old version is gone.
Anything irreversible (data migration, DNS/certificate cutover, external integrations) gets its own checkpoint.

## Rollout strategies (choose per risk)
Rolling (default) · blue/green (instant switch back; double capacity; data compatibility required) · canary
(1% → 5% → 25% → 100% with metric gates and bake time) · regional/tenant waves for large estates · dark launch/
shadow traffic · feature-flag release decoupled from deploy. Define **numeric abort criteria** up front (error
rate, latency percentile, saturation, business KPI) and automate the rollback on breach.

## Go/no-go checklist
- [ ] Scope and change list agreed; dependent teams informed; freeze windows respected
- [ ] Same artifact verified in staging; migrations rehearsed on production-like data volume
- [ ] Infrastructure plan reviewed (no unexpected replace/destroy)
- [ ] Capacity, quotas, certificates, DNS TTLs, secrets and feature flags checked in the target environment
- [ ] Dashboards, alerts and SLOs in place for the new behaviour; on-call aware
- [ ] Backup/restore point taken and restore tested for stateful changes
- [ ] Rollback or roll-forward path written, with decision owner and time limit
- [ ] Verification steps and success criteria written (smoke, synthetic, key user journeys)

## Rollback vs roll-forward
Roll back when the previous version is still compatible with current data and config (the default for
stateless changes). Roll forward when data has changed shape, external systems were updated, or a fix is faster
and safer than reversal. Decide this **before** the release for each change type; rehearse the chosen path.

## Verification after deploy
Automated smoke tests against the new version · synthetic transactions for key journeys · compare canary vs
baseline metrics · error-budget burn alerts · log/trace sampling for new errors · business metrics · bake time
before the next wave. A green pipeline alone is not success.

## Multi-region and DR
Deploy region by region with bake time; keep regions independent (no cross-region runtime dependencies in the
request path); data replication mode known per store; DR runbook exercised (failover and failback); pipeline can
target a single region for emergency fixes.

## Release runbook skeleton (write to the ask's `.docs/` folder)
Purpose and scope · timeline and owners · pre-checks · step-by-step actions with expected result and command/link
· verification per step · abort criteria and rollback steps · communication plan · post-release tasks and
evidence links.

## Regulated environments
Separation of duties (author ≠ approver ≠ deployer where required), change records linked to pipeline runs,
immutable audit logs, evidence retention, production data never in lower environments unmasked. See
`enterprise/regulatory-architecture.md`.

## Interview angles
Zero-downtime deployment with a schema change · designing canary gates · promoting infrastructure changes safely
across 4 environments · what you do when a release fails at 30% rollout · keeping environments in parity.
