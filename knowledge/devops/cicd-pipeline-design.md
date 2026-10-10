# CI/CD Pipeline Design (platform-agnostic)
Last reviewed: 2026-10 | Load when: designing, reviewing, speeding up, securing or migrating pipelines.
Release strategies overview: `devops/cicd-and-release.md`. Failure signatures: `devops/pipeline-and-iac-failure-modes.md`.
⚠️ Platform feature names and limits change — verify syntax for the user's platform/version before writing YAML.

## Design rules
1. **Pipeline as code**, reviewed like application code; shared logic in versioned templates.
2. **Fast feedback**: cheapest checks first; PR validation target ≲ 10 minutes; parallelize and shard tests.
3. **Build once**, produce an immutable artifact (image digest/package) + SBOM + provenance + signature.
4. **Promote, don't rebuild**: the same artifact moves through environments with environment-specific config.
5. **Identity without stored keys**: OIDC federation to the cloud; least privilege per environment.
6. **Deterministic**: pinned toolchains, base images and third-party steps (commit SHA); hermetic where possible.
7. **Idempotent, resumable deploys**; one deploy per environment at a time; never cancel a running prod deploy.
8. **Verification is a stage**: smoke/synthetic tests and health gates decide success, with automatic rollback
   criteria.
9. **Everything observable**: run metadata, durations, failure reasons, DORA metrics.

## Reference stages
`validate` (lint, format, type-check, unit tests, secret scan) → `build` (compile, package, image) →
`analyze` (SAST, SCA, licence, IaC and container scans — gate on new High/Critical) → `publish` (registry +
SBOM + signature) → `deploy-dev` (auto) → `integration/contract/e2e tests` → `deploy-staging` (auto or light
gate; DAST, performance smoke) → `deploy-prod` (approval + progressive rollout + verification) → `post-deploy`
(monitor bake time, release notes, evidence).
Infrastructure follows the same shape: `fmt/validate/lint/scan` → `plan` → review → `apply` (see
`devops/terraform-deep-dive.md`).

## Platform map (concepts are the same; names differ)
| Concept | GitHub Actions | Azure Pipelines | GitLab CI | Jenkins |
|---|---|---|---|---|
| Definition | `.github/workflows/*.yml` | `azure-pipelines.yml` | `.gitlab-ci.yml` | `Jenkinsfile` (declarative/scripted) |
| Reuse | Reusable workflows, composite actions | Templates (`extends`, `template:`), task groups | `include`, `extends`, CI/CD components | Shared libraries |
| Units | workflow → job → step | pipeline → stage → job → step | pipeline → stage → job | pipeline → stage → step |
| Environments & approvals | Environments with required reviewers, wait timers, branch rules | Environments with approvals & checks | Environments, protected environments, approval rules | Input steps / plugins |
| Secrets | Repo/org/environment secrets | Variable groups, Key Vault-linked, secret variables | CI/CD variables (masked/protected), external secrets | Credentials store |
| Cloud identity | OIDC (`id-token: write`) | Workload identity federation service connections | ID tokens (OIDC) | Plugins / cloud-specific auth |
| Runners | GitHub-hosted, self-hosted, runner scale sets | Microsoft-hosted, self-hosted, scale-set agents | Shared/instance, group, project runners (autoscaling) | Controller + agents |
| Conditions | `if:` expressions; `needs` | `condition:`; `dependsOn`; compile-time `${{ }}` vs runtime `$( )`/`$[ ]` | `rules:`; `needs` | `when {}` |
| Matrix / fan-out | `strategy.matrix` | `strategy.matrix`, `each` | `parallel:matrix` | `matrix {}` / parallel |
| Caching | cache action | Cache task | `cache:` keyword | Plugins / workspace reuse |
| Concurrency | `concurrency` groups | Exclusive lock check, `lockBehavior` | `resource_group` | `disableConcurrentBuilds`, lockable resources |
Others: AWS CodePipeline/CodeBuild, Google Cloud Build/Deploy, CircleCI, Buildkite, Tekton, Argo Workflows;
deployment/GitOps layer: Argo CD, Flux, Argo Rollouts, Flagger, Spinnaker, Harness, Octopus.

## Monorepos and many services
Path-based triggers; affected-project detection (Nx/Turborepo/Bazel/Pants); shared pipeline templates with
per-service parameters; remote build cache; avoid one giant pipeline that rebuilds everything.

## Speed levers
Parallel jobs and test sharding · dependency and build caches keyed on lockfiles · incremental/remote-cached
builds · smaller base images and layer ordering · prebuilt toolchain images · selective pipelines (changed paths)
· bigger/closer runners · moving slow suites to nightly with a fast smoke subset on PRs · measuring and removing
the slowest step each sprint.

## Security (see `security/sast-dast-sca-mend.md`, `security/ssdlc.md`)
Minimal default token permissions; environment-scoped secrets; OIDC subjects restricted to repo + branch/
environment; no secrets to fork PRs; third-party steps pinned by SHA and reviewed; signed commits/tags where
required; artifact signing (cosign) and verification at admission; SLSA provenance; ephemeral, isolated runners
for untrusted code; separation of duties and audit trail for production.

## Governance at scale
Golden pipeline templates owned by a platform team; required checks and CODEOWNERS; policy-as-code gates;
exceptions with expiry; pipeline health dashboards (duration, success rate, flaky tests, queue time); DORA
metrics per service.

## Migration between platforms (e.g., Jenkins → GitHub Actions/Azure Pipelines)
Inventory pipelines and plugins → map concepts with the table above → rebuild shared libraries as templates/
reusable workflows → move secrets to the new store with federation → run old and new in parallel and compare
artifacts → cut over per service → retire agents. Don't transliterate line by line; redesign around build-once/
promote.

## Interview angles
Design a pipeline for 50 microservices with shared templates · secure cloud access from CI without long-lived
keys · speed up a 45-minute pipeline · safe database migrations in CI/CD · canary with automatic rollback ·
handling secrets across environments · monorepo strategy.
