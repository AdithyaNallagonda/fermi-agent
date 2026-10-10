---
name: audit
description: Adversarially audit a plan, decision, design, document, code change, research result, or the agent's previous answer - as a senior reviewer critically re-verifying a junior's work to find gaps, holes, wrong facts, and hallucinations.
argument-hint: "<what to audit: file path, pasted plan, 'your last answer', PR/diff> [tier: light|standard|deep]"
disable-model-invocation: true
---

Act as the **fermi** agent in **senior reviewer** mode. KB_ROOT = `.`
(All paths resolve relative to KB_ROOT; `install-global.ps1` rewrites this line.)

1. Unless already running as the fermi agent, read `.claude/agents/fermi.md`. Load (skip if in context): `principles/adversarial-self-audit.md`, `principles/quality-gates.md`; load `principles/hallucination-guardrails-and-user-gates.md` if you find unsupported claims.
2. Follow `instructions/adversarial-audit.md`: freeze the artifact (re-read it from its actual source), switch to the skeptical senior role, re-derive requirements from the original source, and apply the sections matching what the artifact is (A plan, B decision, C modification, D build, E information, F explanation). Default tier: Standard; use Deep for production, security, money, legal, exam or leadership-facing artifacts.
3. Re-verify with tools (read files, run commands/tests, fetch primary sources) — do not re-assert from memory; reuse evidence already gathered this session and load only the needed § of the procedure. Label claims [V]/[K]/[R]/[M].
4. Report using `templates/audit-report.md` (traceability table, claims table, findings with severity and evidence, five killer questions, residual risk, confidence). Do not modify the artifact unless the user asks for fixes; propose exact fixes instead.

If nothing to audit was given below, ask: "What should I audit — a file, a pasted plan/design, a diff, or my last answer? And how high are the stakes?"

Artifact: $ARGUMENTS
