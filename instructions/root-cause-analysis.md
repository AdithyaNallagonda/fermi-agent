# Playbook: Debugging & Root Cause Analysis (any system)

Principles: `principles/diagnostic-reasoning.md`, `principles/hallucination-guardrails-and-user-gates.md`.
Knowledge: `knowledge/fundamentals/failure-modes-and-bug-patterns.md` (signatures of hard bugs), plus domain files
(`databases/dba-diagnostics-cheatsheet.md`, `networking/*`, `devops/containers-and-kubernetes.md`, engine/cloud files).
Template: `templates/rca-report.md`.

## Step 0 — Triage (only if live incident)
Is it ongoing, how severe, what's the blast radius? Suggest **safe mitigations** first (roll back the last change,
fail over, scale out, disable a feature flag, shed load) — each needs Gate G4 unless pre-authorized — then diagnose.

## Step 1 — Context intake (Gate G1 — ask before hypothesizing deeply)
Always ask for whatever is missing from this core set (batch ≤ 4 questions per round; ask for artifacts, not
interpretations):
1. **Symptom verbatim**: exact error text/codes, stack trace, screenshot; expected vs actual.
2. **When & scope**: start time (timezone), frequency (always / intermittent / under load / time-of-day), who/what
   is affected vs not (users, regions, AZs, pods, versions, endpoints, data shapes).
3. **Changes**: deploys, config/flag changes, dependency/library upgrades, infra/network/IAM/cert changes, data
   growth, traffic changes — in the window before onset.
4. **Environment**: versions (runtime, framework, engine, OS, SDKs), managed services, topology.
5. **Evidence**: logs around the event (with correlation IDs), metrics (latency/errors/saturation), traces, config
   files, relevant code paths.
6. **Repro**: steps, rate of reproduction, minimal case; what has already been tried and the result.

Domain add-ons (ask only the relevant ones):
| Domain | Extra context |
|---|---|
| Code / app | Language/runtime version, the failing function & call path, inputs that fail vs succeed, concurrency model, recent commits (`git log`/diff), test results |
| Network | Source/destination, protocol/port, DNS answers, traceroute/mtr, TLS details (SNI, cert chain/expiry), SG/NACL/NSG/firewall rules, LB/proxy idle timeouts, MTU, NAT/egress path |
| Database | Engine+version, query text + plan, waits/locks, replication status, recent DDL/stats/parameter changes, connection counts (see DBA cheat sheet) |
| Distributed / messaging | Timeouts & retry policies per hop, idempotency, queue depth/lag/DLQ, ordering assumptions, clock sync, partial-failure handling |
| Kubernetes / containers | Pod events (`kubectl describe`), restarts/OOMKilled, resource requests/limits, probes, node pressure, DNS (`ndots`), network policies, image/tag |
| Cloud / IAM | Exact AccessDenied message + action/resource ARN, SCP/RCP/permission boundaries, region, quotas/throttling metrics, recent policy changes |
| Frontend | Browser/version, console & network tab (status, CORS preflight), cache headers, service worker, build version served |
| CI/CD, Terraform, deployments | First error in the log, failing step + exit code, run ID, last green run vs this run, tool/provider/action versions, plan output, which identity ran (use `knowledge/devops/pipeline-and-iac-failure-modes.md`) |
| Data pipelines | Input partition/date, schema changes, row counts per stage, late/duplicate data, job retries/bookmarks |
| Performance | Baseline vs now, percentiles (p50/p99), load level, saturation signals, GC/thread-pool metrics |
If the workspace contains the code/config, **read it yourself** (Grep/Read, `git log -p`) instead of asking.

## Step 2 — Build the timeline
Correlate events on one clock (normalize timezones): changes → first symptom → escalation → mitigations. Note gaps.

## Step 3 — Differential diagnosis (ranked)
Generate 4–8 hypotheses across layers; consult `failure-modes-and-bug-patterns.md` for signatures that match.
Present:
| # | Hypothesis (mechanism) | Explains which symptoms | Evidence for | Evidence against / gaps | Likelihood | Next discriminating check (cost/risk) |
|---|---|---|---|---|---|---|
Likelihood = High/Medium/Low **with the reason** (fit, base rate, recency of related change). Always include
"Other/unknown". If evidence is too thin to rank → say so and return to Step 1 with targeted questions (tripwire T6).

## Step 4 — Discriminating tests
Order checks by information gain ÷ (cost + risk): logs/metrics queries → config diff → read code path → targeted
reproduction in non-prod → controlled experiment (toggle one variable) → production change (G4). Give exact,
version-verified commands/queries; mark anything that writes or is heavy. Update the table after each result
(promote, demote, rule out — say why).

## Step 5 — Root cause statement
Only when a hypothesis is **Confirmed** (or clearly labeled **Probable** with what would confirm it):
- **Trigger** → **Causal chain/mechanism** (step by step, each link evidenced) → **Root cause** (why the system
  allowed it) → **Contributing factors** (detection gaps, missing guardrails, process) → **Why it wasn't caught**.
- Use 5 Whys for depth and a fishbone (people/process/technology/data/environment) for breadth when useful.

## Step 6 — Fix, verify, prevent
Immediate fix / workaround · permanent fix · verification (metric/test that proves it; reproduction no longer
fails) · prevention for the **class** of issue (tests, alerts, limits, timeouts, guardrails-as-code, runbooks,
chaos test) · follow-up actions with owners. Keep the evidence, timeline and hypothesis table in this ask's
`.docs/` folder (`rca.md` from `templates/rca-report.md`; queries/log extracts in `scratch/`); chat gets the verdict.

> **Audit checkpoint (E + B, Deep for production incidents) — before declaring the RCA:** every link in the causal
> chain has evidence (label [V]/[K]/[R]); no unexplained symptom remains (or it's listed); alternatives ruled out
> with stated evidence; commands verified for the exact versions; confidence label honest.

## Final step — Adversarial audit (mandatory)
Tier: **Deep** for production incidents/security; Standard otherwise. Ask: "What symptom does my RCA *not* explain?
What evidence would prove me wrong, and did I look for it?" Unsupported link → tripwire STOP, ask for the
evidence. End with the 🔍 audit summary.
