# Playbook: DevOps Engineering (CI/CD, Terraform/IaC, production deployments)

Principles: `principles/devops-principles.md` (+ `security-principles.md` for pipeline/supply-chain security).
Knowledge: `knowledge/devops/cicd-pipeline-design.md`, `knowledge/devops/terraform-deep-dive.md`,
`knowledge/devops/pipeline-and-iac-failure-modes.md`, `knowledge/devops/multi-environment-deployment.md`,
plus `devops/containers-and-kubernetes.md` and the cloud files as needed.
Tools: Azure DevOps and GitHub MCP servers for pipeline runs, logs, PRs (`knowledge/ai/bundled-tools.md`);
Mermaid/draw.io for pipeline and topology diagrams. Read the repo's pipeline and Terraform files yourself.

**Gate G1**: CI/CD platform (GitHub Actions / Azure Pipelines / GitLab CI / Jenkins / other) and version,
cloud(s), IaC tool **and version** (Terraform vs OpenTofu, provider versions, backend), runtime (Kubernetes/
serverless/VMs), environments and how they're isolated, branching model, compliance constraints, current pain
(speed, failures, drift, security). Don't write platform syntax without knowing the platform and version.

## Pick the track
| Track | Trigger |
|---|---|
| A. Pipeline design / review | New pipeline, slow/unreliable pipeline, migration between CI platforms |
| B. Terraform / IaC design & operations | Module/state layout, new stack, refactor, import, upgrade, drift |
| C. Failure diagnosis | Pipeline, Terraform, or deployment failed or behaves intermittently |
| D. Production release across environments | Rollout plan, go-live, cutover, rollback design |
| E. Pipeline & supply-chain security | Secrets, OIDC, permissions, provenance, policy gates |

## A. Pipeline design / review
1. Map the value stream: commit → build → test → scan → package → deploy(env₁…envₙ) → verify. Time each stage.
2. Design stages with fast feedback first (lint/unit < ~10 min), **build once**, artifact + SBOM + signature,
   then promote. Reuse via templates/reusable workflows; path filters for monorepos.
3. Identity & secrets: OIDC to cloud per environment, least-privilege roles, vault-backed secrets.
4. Gates: required checks, security scans (diff-aware), policy-as-code, environment approvals for prod.
5. Reliability: deterministic builds, pinned tool/action versions (by SHA), cache keys from lockfiles, retries
   only for known-transient steps, concurrency control for deploys (never cancel a running prod deploy).
6. Deliver: pipeline diagram (Mermaid), the pipeline code, a short runbook, and measurable targets (duration,
   success rate, DORA).

## B. Terraform / IaC
1. Layout: state per environment × component by blast radius; module strategy (small, versioned, tested);
   environment strategy (directories, Terragrunt, or Stacks) — justify.
2. Standards: pinned `required_version` and providers, committed lock file with CI platform hashes, remote
   locked encrypted backend, naming/tagging, `for_each` with stable keys, validations/pre-postconditions.
3. Workflow: PR → fmt/validate/lint/scan → **plan (saved)** → review → apply the saved plan with the apply role;
   drift detection on a schedule.
4. Risky operations (**each needs G4 + state backup + rollback note**): `state mv/rm/push`, `force-unlock`,
   `import`, `-replace`, `-target`, `destroy`, backend migration, provider major upgrades, anything the plan
   marks as replace/destroy on stateful resources. Prefer `moved` / `removed` / `import` blocks (reviewable in PR)
   over CLI state commands.
5. Always **read the plan summary aloud** to the user: counts of add/change/destroy, every replacement and why
   ("forces replacement"), and anything touching data stores, networking, IAM or DNS.

## C. Failure diagnosis (pipeline · Terraform · deployment)
Run `instructions/root-cause-analysis.md` with the DevOps lens:
1. Collect: the **first** error in the log (not the last), the failing step and exit code, run URL/ID, what
   changed since the last green run (code, pipeline, versions, secrets, infra), and whether it's deterministic.
   Pull logs with the Azure DevOps / GitHub tools when available.
2. Match signatures in `knowledge/devops/pipeline-and-iac-failure-modes.md` → ranked hypotheses.
3. Discriminate cheaply: compare a passing vs failing run (env, versions, inputs), re-run with debug logging
   (`TF_LOG=DEBUG`, `ACTIONS_STEP_DEBUG`, `system.debug`), reproduce locally or in a scratch environment.
4. Fix the cause, not the symptom; add a guard (check, test, alert, pin) so the class of failure can't recur.
5. Mid-apply/mid-deploy failures: establish the **current real state** first (what was created, what the state
   file recorded, which version is serving traffic) before any retry.

## D. Production release across environments
Use `knowledge/devops/multi-environment-deployment.md`: release plan (scope, order infra → data → app → config →
traffic), promotion evidence from lower environments, go/no-go checklist, rollout strategy (canary/blue-green/
rolling, waves for regions/tenants), database change plan (expand/contract), rollback or roll-forward criteria
with numbers, verification (smoke, synthetic, SLO burn, bake time), communication, post-release review.
Write the runbook to the ask's `.docs/` folder; production steps are executed only after G4.

## E. Pipeline & supply-chain security
Least-privilege pipeline permissions; OIDC subjects bound to repo + branch/environment; secrets never echoed;
fork-PR isolation; actions/tasks pinned by commit SHA; dependency and image scanning; SBOM + provenance (SLSA);
artifact signing and verification at deploy; protected branches/environments; separation of duties for prod.

> **Audit checkpoint (D + B + E) — before giving pipeline code, Terraform, or a release plan:** syntax valid for
> the stated platform/tool version (validate or state that it wasn't run), every destructive/irreversible step
> gated with backup + rollback, secrets handled by reference, plan/blast radius stated, verification defined.

## Final step — Adversarial audit (mandatory)
Tier: **Deep** for anything touching production, state, or credentials; Standard for design/review. Apply §D
(run `terraform fmt/validate`, lint, or a pipeline syntax check where possible), §E (version-specific features
verified), §B (alternatives), §A (release plan traceability). Unverified flag/argument/feature → tripwire STOP.
End with the 🔍 audit summary.
