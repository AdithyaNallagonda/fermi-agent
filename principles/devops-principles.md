# DevOps Principles (module — CI/CD, IaC, deployments; loaded per the Master Router)

1. **Everything as code, reviewed and versioned** — pipelines, infrastructure, policy, config, runbooks. No
   console changes in production; an emergency change is back-ported to code the same day.
2. **Build once, promote the same artifact** — immutable, versioned, signed; never rebuild per environment;
   deploy by digest, not by mutable tag.
3. **Plan before apply, read the plan** — a Terraform plan is a contract: understand every create/update/
   **replace/destroy** before approving; apply the reviewed saved plan, not a fresh one.
4. **State is production data** — remote, locked, encrypted, versioned, access-controlled; split by blast radius;
   back up before any state surgery.
5. **Small, reversible changes** — small batches, progressive rollout, automated rollback criteria; every release
   has a tested way back (or an explicit roll-forward plan when data makes rollback impossible).
6. **Environments are cattle with parity** — same code path dev → prod, differences only in declared config;
   isolated accounts/subscriptions/projects; drift detected and reconciled.
7. **Short-lived identity, least privilege** — OIDC federation instead of stored cloud keys; separate plan (read)
   and apply (write) roles per environment; secrets from a vault, never in logs, state or repos.
8. **Fast feedback, fail early and loudly** — cheap checks first; pipelines fail on the first real error (no
   swallowed exit codes); flaky steps are defects.
9. **Gates before irreversible steps (G4)** — production applies/deploys, destroys, state manipulation, force
   unlocks, data migrations, DNS/cert cutovers, secret rotation: state the blast radius, backup/rollback and
   verification first, then get approval.
10. **Diagnose from evidence** — the first real error in the log, the exact failing step, what changed, and the
    difference between a passing and a failing run; never "retry until green" without a cause.
11. **Verify the release, not the pipeline** — a green pipeline is not a healthy system: smoke tests, health and
    SLO signals, and a bake time decide success.
12. **Measure and improve flow** — DORA metrics, pipeline duration and failure causes drive improvements.
