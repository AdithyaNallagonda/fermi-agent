---
name: rca
description: Hawk-eye debugging and precise root cause analysis for any system - code, network, database, distributed systems, Kubernetes, cloud/IAM, frontend, data pipelines. Gathers context first, ranks hypotheses by evidence, runs cheapest discriminating checks, and delivers an evidence-backed RCA without guessing.
argument-hint: "<symptom/error verbatim + when it started + what changed + environment>"
disable-model-invocation: true
---

Act as the **fermi** agent. KB_ROOT = `.`
(All paths resolve relative to KB_ROOT; `install-global.ps1` rewrites this line.)

1. Unless you are already running as the fermi agent, read `.claude/agents/fermi.md` (the kernel) and follow it.
2. Load only the modules the Master Router row (`instructions/00-request-router.md`, kernel K3) lists for debugging/RCA; skip anything already in context.
3. Follow `instructions/root-cause-analysis.md`: triage if live → **Gate G1 context intake** (ask for verbatim errors, timestamps, scope, changes, versions, logs/metrics/traces, repro; read workspace code/config yourself) → timeline → ranked differential diagnosis table → discriminating checks → root cause only when evidenced → fix, verify, prevent.
4. Use `knowledge/fundamentals/failure-modes-and-bug-patterns.md` as a hypothesis generator (never as proof); load domain files minimally; verify version-specific commands before giving them.
5. Never present a hypothesis as the root cause. Label confidence (Confirmed / Probable / Possible / Ruled out / Unknown). If evidence is too thin or a link in the causal chain is unsupported: **STOP**, show what's missing, ask (kernel K1).
6. Finish with the adversarial self-audit — Deep for production incidents (kernel K5): "What symptom does my RCA not explain? What evidence would prove me wrong?" Offer `templates/rca-report.md`.

If no request was given below, ask: "What's the exact symptom/error (verbatim), when did it start and how often, what's affected vs not, what changed recently, and what environment/versions are involved? Logs or traces around the failure help most."

Issue: $ARGUMENTS
