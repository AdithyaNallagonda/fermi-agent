# Pipeline, Terraform & Deployment Failure Modes (diagnostic signatures)
Last reviewed: 2026-10 | Load when: a CI/CD run, Terraform plan/apply, or deployment fails
(`instructions/devops-engineering.md` track C → `instructions/root-cause-analysis.md`).
Signatures generate hypotheses; the **confirming check** decides. Error texts are typical wordings — match on
meaning, and verify tool/version-specific details before prescribing commands ⚠️.

## First moves (every failure)
Find the **first** error (later ones are usually consequences) · exact step, command and exit code · last green
run vs this run: what changed (commit, pipeline file, tool/provider/action version, secret, runner image, infra)?
· deterministic or intermittent? · same failure on re-run with debug logging?

## Terraform / OpenTofu
| Signature | Likely cause | Confirming check → fix |
|---|---|---|
| `Error acquiring the state lock` | Another run active, or a cancelled/crashed run left the lock | Check running pipelines/users; lock info shows who/when → if truly orphaned, `force-unlock <ID>` (G4). Add pipeline concurrency per state |
| `Saved plan is stale` | State changed between plan and apply | Re-plan and re-approve; serialize applies |
| Plan shows `must be replaced` / `# forces replacement` unexpectedly | Immutable attribute changed, provider upgrade changed a default, `count` index shift, `for_each` key changed, resource renamed without `moved` | Read which attribute forces replacement; `moved` block for renames; stable keys; pin provider |
| Plan never becomes clean (perpetual diff) | Provider normalizes the value (JSON key order, case, defaults), another system mutates the field, computed value in config | Compare state vs config for that attribute; canonicalize (`jsonencode`), or narrow `ignore_changes` |
| `Invalid for_each argument … cannot be determined until apply` (same for `count`) | Keys derived from not-yet-created resource attributes | Use static keys known at plan; split into two applies only as a last resort |
| `Cycle: …` | Circular references (often security groups referencing each other, or `depends_on` loops) | `terraform graph` to see it; break with separate rule resources / remove `depends_on` |
| `Provider configuration not present` | A module/provider block was removed while its resources remain in state | Restore the provider config, or declare `removed`/destroy first |
| `Inconsistent dependency lock file` / checksum mismatch in CI | Lock file lacks hashes for the CI platform, or provider version bumped without updating the lock | `terraform providers lock -platform=…`; commit the lock file |
| `state snapshot was created by Terraform vX, which is newer` | Someone applied with a newer CLI | Pin `required_version`; standardize CLI in CI and laptops; upgrade deliberately |
| `Backend configuration changed` on init | Backend block/params differ from `.terraform` | `init -migrate-state` (move) vs `-reconfigure` (ignore) — choose deliberately |
| 403 / `AccessDenied` / `AuthorizationFailed` at apply though plan passed | Plan role is read-only by design, missing write permission, SCP/permission boundary/Azure Policy deny, wrong account/subscription | Read the exact API action + resource in the error; check org-level policies and which identity ran |
| Auth error minutes into a long apply (`ExpiredToken`, `token is expired`) | Federated/assumed-role session shorter than the run | Raise session duration, split the stack, refresh credentials |
| `EntityAlreadyExists` / `409 Conflict` / "already exists" | Created out of band, or a previous apply failed before the state was written | Confirm it's the same resource → `import` block |
| `DependencyViolation` / "in use" / non-empty bucket on destroy | Out-of-band dependents (ENIs, attachments, objects, locks) | Find dependents via console/CLI; remove or import them |
| Create fails right after its dependency was created (IAM role, service principal, DNS) | Eventual consistency in the cloud API | Re-run; add explicit dependency or a short wait; provider retries |
| Timeout creating (databases, clusters, CDNs) | Legitimately slow resource, or it's stuck on a quota/health condition | Check the resource's own events; raise the `timeouts` block; check quotas |
| `ThrottlingException` / 429 / `RequestLimitExceeded` | Too many parallel API calls | Lower `-parallelism`; stagger pipelines |
| Apply failed midway | Normal: completed resources are in state | Re-plan to see the remainder; if the backend write failed, restore from `errored.tfstate` with `state push` (G4) |
| Diff appears only on some machines | CRLF vs LF or path differences feeding `file()`/hash functions | Normalize line endings (`.gitattributes`); avoid OS-dependent paths |
| Secret visible in plan/logs | Value not marked sensitive, or echoed by a script/provisioner | Mark sensitive; move to ephemeral/write-only; rotate the exposed secret |

## CI/CD pipelines
| Signature | Likely cause | Confirming check → fix |
|---|---|---|
| Passes locally, fails in CI | Tool/runtime version drift, missing env var/secret, case-sensitive filesystem, locale/timezone, CRLF, network egress | Print versions and env in CI; pin toolchain; containerize the build |
| Fails only on pull requests from forks | Secrets and write tokens are withheld from fork PRs by design | Split untrusted build from privileged steps; don't loosen this |
| Versioning/changelog/blame steps break | Shallow clone (`fetch-depth: 1`) or missing tags | Fetch full history/tags for those jobs |
| Intermittent test failures | Shared state, order dependence, time/timezone, real network calls, parallelism races | Re-run the single test N times; isolate; quarantine with an owner, don't blanket-retry |
| Stale or wrong build output | Cache key too broad (not tied to lockfile/toolchain), poisoned cache, restore-keys fallback | Bust the cache once; key on lockfile hash + OS + tool version |
| "Tested artifact ≠ deployed artifact" bugs | Rebuilding per environment, or deploying a mutable tag (`latest`) | Build once; promote by digest |
| `Not authorized to perform sts:AssumeRoleWithWebIdentity` / `AADSTS70021/700213 No matching federated identity record` | OIDC subject/audience mismatch: branch vs tag vs environment vs pull_request, renamed repo/environment | Print the token's `sub`/`aud` claims; match the trust policy/federated credential exactly |
| Secret is empty or `***` breaks a command | Not available in this context (fork, environment-scoped, wrong variable group), expired credential, masked value transformed | Check secret scope/environment; rotate expired service-principal secrets/certs |
| Step "succeeds" but nothing happened / failure hidden | Missing `set -euo pipefail`; exit code swallowed by `| tee`, `|| true`, or a wrapper script | Check each command's exit code; fix the shell options |
| Job skipped or runs when it shouldn't | Condition semantics: dependent job failed/skipped; `always()`/`succeededOrFailed()`; compile-time vs runtime expressions (Azure `${{ }}` vs `$( )` vs `$[ ]`); string vs boolean inputs | Evaluate the condition with the actual values; pass outputs explicitly between jobs/stages |
| Exit 137 / runner "lost communication" | Out of memory, or the (spot/ephemeral) runner was reclaimed | Runner metrics; reduce parallelism, bigger runner, test sharding |
| `No space left on device` | Runner disk full (images, caches, artifacts) | Prune; smaller base images; clean workspace |
| `toomanyrequests` pulling images | Registry rate limit (unauthenticated pulls) | Authenticate; mirror/cache images in your registry |
| A tagged action/task suddenly behaves differently | Mutable version tag moved or the dependency was compromised (e.g., the tj-actions/changed-files incident, 2025) | Pin third-party actions by commit SHA; review updates |
| Deploy cancelled halfway by a newer commit | Concurrency setting cancels in-progress runs | Never cancel in-progress deploy/apply jobs; queue them |
| Long queue times | Runner capacity/concurrency limits | Autoscale runners; split pipelines; cache better |

## Deployments
| Signature | Likely cause | Confirming check → fix |
|---|---|---|
| Rollout hangs or times out | Readiness probe never passes: wrong port/path, missing config/secret, dependency unreachable, migrations still running | Pod/task events and container logs; `kubectl rollout status` / `describe` |
| `ImagePullBackOff` / `ErrImagePull` | Tag doesn't exist, registry auth, private network path | Verify digest exists; pull secret/identity; registry firewall |
| `exec format error` | CPU architecture mismatch (amd64 image on arm64 nodes or vice versa) | Build multi-arch images; node selectors |
| `CrashLoopBackOff` right after deploy | Bad config, missing env/secret, failed startup migration, OOM (137) | Previous container logs (`--previous`), events |
| Errors only during the rollout, fine afterwards | Old and new versions incompatible (schema/API/cache/session), no graceful shutdown | Expand/contract migrations; backward-compatible changes; preStop + termination grace |
| Green pipeline, broken production | Health check too shallow, no smoke test, config differs between environments, feature flag state | Add post-deploy verification; diff environment config |
| Works in staging, fails in prod | Scale/data volume, quotas, network policy, IAM, secrets, DNS/certificates, region differences | Diff the environments systematically (infra code, config, limits) |
| Rollback doesn't fix it | A data migration or external state already changed | Roll forward with a fix; restore data only with a rehearsed plan |
| Helm/GitOps shows drift or "another operation in progress" | Interrupted release, manual changes, controller fighting a pipeline | Release history/status; single owner of the resource |

## After the fix
Add the guard that would have caught it (pin, check, test, alert, policy) and record the cause in the ask's
`.docs/` folder so the same failure is recognised next time.
