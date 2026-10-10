# CI/CD & Release Engineering
Last reviewed: 2026-10

Pipeline design in depth: `devops/cicd-pipeline-design.md`. Releases across environments:
`devops/multi-environment-deployment.md`. Failure diagnosis: `devops/pipeline-and-iac-failure-modes.md`.

## Pipeline stages (reference)
1. **Commit/PR**: lint, format, unit tests, SAST, secrets scan, SCA (Mend/Dependabot), IaC scan, build,
   preview environments.
2. **Build**: reproducible build, SBOM, container image scan, sign artifacts, push to registry.
3. **Test**: integration, contract tests, API tests, DAST (staging), performance smoke.
4. **Deploy**: progressive delivery to staging → prod with approvals for regulated systems.
5. **Verify**: synthetic checks, SLO-based automated rollback.

## Deployment strategies
| Strategy | Risk | Cost | Notes |
|---|---|---|---|
| Rolling | Medium | Low | Default in K8s/ECS |
| Blue/green | Low (instant rollback) | 2× capacity briefly | DB migrations must be backward compatible |
| Canary | Low | Small | Shift % traffic with metric gates (Argo Rollouts, Flagger, CodeDeploy, App Service slots) |
| Feature flags | Lowest | Tooling | Decouple deploy from release (LaunchDarkly, Unleash, AppConfig, OpenFeature) |
| Shadow / dark launch | None to users | Extra compute | Test with mirrored traffic |
**Expand/contract** DB migrations: add new → dual-write/backfill → switch reads → remove old.

## GitOps
Desired state in Git; controllers (Argo CD/Flux) reconcile clusters; PR-based changes; drift detection.

## Branching
Trunk-based development with short-lived branches + feature flags (preferred for CI/CD); GitFlow for
release-train products with long stabilization (heavier).

## DORA metrics
Deployment frequency, lead time for changes, change failure rate, failed deployment recovery time (plus
reliability). Elite teams deploy on demand with < 1 day lead time.

## Platforms
GitHub Actions (OIDC to clouds — no static keys), GitLab CI, Azure DevOps Pipelines, Jenkins (legacy,
plugin risk), AWS CodePipeline/CodeBuild, Google Cloud Build/Deploy, Harness, Spinnaker.

## Supply-chain security
SLSA levels, provenance attestations, signed commits, protected branches, required reviews, pinned
actions by SHA, ephemeral runners, least-privilege pipeline identities.
