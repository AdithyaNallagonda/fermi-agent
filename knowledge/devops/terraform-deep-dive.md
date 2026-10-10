# Terraform / OpenTofu — Deep Dive
Last reviewed: 2026-10 — versions verified 2026-10-10 via GitHub releases API, endoflife.date and the official
changelogs: **Terraform 1.16.5** (supported lines 1.16, 1.15; 1.14 EOL Aug 2026) · **OpenTofu 1.13.1**
(supported 1.13, 1.12) · Terragrunt 1.1.6. ⚠️ Confirm a feature exists in the user's exact version before using it.
Load when: IaC design, Terraform reviews, state operations, upgrades, Terraform interviews.
Failure signatures: `devops/pipeline-and-iac-failure-modes.md`. Overview of other IaC tools: `devops/infrastructure-as-code.md`.

## Mental model
Three things must agree: **configuration** (desired) · **state** (Terraform's record: address → real ID +
attributes) · **reality** (the provider's API). `plan` = refresh state from reality → build the dependency graph
→ diff desired vs recorded → propose create / update-in-place / **replace** / destroy. `apply` walks the graph in
dependency order (parallelism 10 by default). Most incidents are a disagreement between two of the three.

## State (treat as production data)
- **Backends with locking**: S3 (`use_lockfile = true` native lock file since 1.10; **DynamoDB locking is
  deprecated**), Azure Blob (lease lock), GCS, HCP Terraform, Postgres, Kubernetes. Enable bucket versioning +
  encryption; restrict access (state holds secrets and full topology).
- **Split by blast radius and change cadence**: per environment × component (network, data, platform, app). Huge
  single states = slow plans, risky applies, lock contention.
- **Cross-stack data**: prefer published values (SSM Parameter Store / Key Vault / outputs via a data source) over
  tight `terraform_remote_state` coupling (which also needs read access to the whole state).
- **Refactor without recreate**: `moved` blocks (rename/move into modules), `removed` blocks (forget without
  destroying, 1.7+), `import` blocks (1.5+; inside modules since 1.16) with `-generate-config-out`. These are
  reviewable in PRs — prefer them to `terraform state mv/rm/import` CLI surgery.
- **Discovery**: `terraform query` + list resources in `*.tfquery.hcl` (1.14+) to find unmanaged resources and
  generate import config.
- **Surgery rules**: `terraform state pull > backup.tfstate` first; never hand-edit; `force-unlock` only after
  proving no run is active; `state push` only to restore a known-good or `errored.tfstate`.
- OpenTofu adds **client-side state/plan encryption** (1.7+).

## Language essentials that prevent outages
- **`for_each` over `count`** for collections: `count` index shifts destroy/recreate neighbours; `for_each` keys
  must be **known at plan time** and stable (names, not generated IDs).
- **`lifecycle`**: `create_before_destroy` (zero-downtime replacement; names must not collide),
  `prevent_destroy` (stateful resources), `ignore_changes` (fields owned by another system — use narrowly),
  `replace_triggered_by`.
- **Validation layers**: variable `validation`, `precondition`/`postcondition`, `check` blocks (continuous
  assertions, non-blocking).
- **Secrets**: `sensitive = true` only hides output — the value is still in state. Keep secrets out of state with
  **ephemeral resources/variables** (1.10+) and **write-only arguments** (1.11+); `terraform_data` `store` block
  for ephemeral/sensitive values across plan/apply (1.16+). OpenTofu: ephemeral from 1.11.
- **Dependencies**: implicit references first; `depends_on` only for hidden dependencies (it widens the blast
  radius and defers data sources).
- **Providers**: pin with `~>`; alias for multi-region/account; reusable modules declare
  `required_providers`/`configuration_aliases` but **do not configure providers**.
- **Actions** (1.14+): provider-defined operations outside CRUD (e.g., invoke a function, invalidate a cache),
  triggered on lifecycle events; `on_failure` modes in 1.16. Provisioners remain a last resort.
- 1.15: variables/locals allowed in module `source`/`version`; `deprecated` on variables/outputs; typed outputs;
  `validate` checks the backend block. 1.16: `terraform graph -format=mermaid`, `state show -json`.

## Module design
Small, single-purpose, composable; typed inputs with validation and sensible defaults; minimal outputs;
semantic versions (registry or git tags) and a changelog; examples + tests in the module repo; no hard-coded
regions/accounts; avoid deep nesting (> 2 levels) and "one module to rule them all". Root modules (stacks) wire
modules together per environment/component and own backend + provider configuration.

## Environment strategy
| Approach | How | Fits | Watch |
|---|---|---|---|
| Directory per environment | `envs/prod/network` etc., shared modules, own backend/tfvars | Most teams; explicit, reviewable | Some duplication of wiring |
| Terragrunt | DRY backend/provider generation, dependency graph, `run --all` | Many stacks/accounts | Extra tool; keep units small |
| CLI workspaces | Same config, multiple states | Ephemeral/preview copies | Weak isolation; easy to apply to the wrong one — avoid for prod separation |
| HCP Terraform workspaces / **Stacks** | Managed runs, policy, orchestration across components/deployments | Enterprises on HCP | Platform coupling ⚠️ verify Stacks features for your tier |
Always: separate cloud accounts/subscriptions/projects per environment; promote by **module version**, not by
copying code.

## Quality gates
`terraform fmt -check` → `validate` → TFLint → security/misconfiguration scan (Checkov / Trivy config / KICS) →
**`terraform test`** (1.6+; plan- or apply-mode runs, mocks) and/or Terratest for real infrastructure →
policy-as-code on the plan JSON (OPA/Conftest, Sentinel on HCP) → cost diff (Infracost) → human review of the plan.

## CI/CD workflow (reference)
1. PR: `init -input=false` → checks above → `plan -out=tfplan -input=false -lock-timeout=5m` → publish a readable
   plan summary to the PR → approval.
2. Merge/release: **apply the saved plan** (`terraform apply tfplan`) with the environment's apply role. If the
   state changed since planning Terraform rejects it as stale → re-plan, never force.
3. Identity: OIDC federation per environment; read-only role for plan, write role for apply; no long-lived keys.
4. Serialize runs per state (pipeline concurrency group + backend lock). Set `TF_IN_AUTOMATION=1`.
5. Commit `.terraform.lock.hcl`; add hashes for every platform that runs Terraform
   (`terraform providers lock -platform=linux_amd64 -platform=windows_amd64 -platform=darwin_arm64`).
6. Scheduled **drift detection**: `terraform plan -detailed-exitcode` (0 = no changes, 1 = error, 2 = changes) →
   alert/ticket.

## Operations cookbook
- Force one resource to be rebuilt: `-replace=ADDRESS` (replaces the deprecated `taint`).
- `-target` is for emergencies and bootstrapping only; follow with a full plan.
- Backend change: `init -migrate-state` (moves state) vs `init -reconfigure` (ignores existing state — dangerous if
  you meant to migrate).
- Throttling: lower `-parallelism`; large states: split, and use `-refresh=false` only with care.
- Provider major upgrades: read the upgrade guide, upgrade in a branch, expect plan diffs from changed defaults,
  roll through environments.
- Slow/blocked destroys: find out-of-band dependents; protect data with `prevent_destroy` and deletion protection.

## Terraform vs OpenTofu (2026)
| | Terraform | OpenTofu |
|---|---|---|
| License / steward | BUSL-1.1, HashiCorp (an IBM company) | MPL-2.0, Linux Foundation |
| Latest | 1.16.x | 1.13.x |
| Notable own features | Stacks, `terraform query`/list resources, Actions, HCP integration, Sentinel | State & plan encryption (1.7), early variable evaluation (1.8), provider `for_each` and `-exclude` (1.9), OCI registry support (1.10), ephemeral (1.11) |
State and most configurations remain compatible, but features have diverged — pick one per organization, pin
it, and don't mix them on the same state.

## Anti-patterns
One giant state · workspaces as prod/non-prod boundary · `count` over lists of objects · secrets in tfvars/state ·
`depends_on` everywhere · provisioners for configuration management · unpinned providers/modules · applying from
laptops · `-target` as routine · `ignore_changes = all` · console hotfixes never back-ported.

## Interview angles
State locking and what to do with a stuck lock · `count` vs `for_each` · zero-downtime replacement · importing
existing infrastructure at scale · drift handling · multi-account/multi-region design · keeping secrets out of
state · refactoring a monolithic state without downtime (`moved`, state split, import) · plan/apply separation in CI.
