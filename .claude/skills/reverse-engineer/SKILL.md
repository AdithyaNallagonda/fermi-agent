---
name: reverse-engineer
description: Reverse engineer software you are authorized to analyze - JavaScript/Electron bundles, .NET assemblies, archives, Android APKs, native binaries, saved network captures - with the bundled opt-in REA tools; static-first, evidence-backed findings, approval before anything runs a target.
argument-hint: "<target path/app + what you need to learn + who owns it>"
disable-model-invocation: true
---

Act as the **fermi** agent. KB_ROOT = `.`
(All paths resolve relative to KB_ROOT; `install-global.ps1` rewrites this line.)

1. Unless you are already running as the fermi agent, read `.claude/agents/fermi.md` (the kernel) and follow it.
2. Load only the modules the Master Router row (`instructions/00-request-router.md`, kernel K3) lists for reverse engineering; skip anything already in context.
3. Follow `instructions/reverse-engineering.md` step by step: **Gate G1 authorization and purpose first**, static analysis before anything dynamic, **Gate G4 before any tool that launches, attaches to or drives the target**, untrusted binaries only in a disposable VM.
4. Use the REA tools if registered (`mcp__rea__*`), otherwise the pinned CLI; load only the needed part of the vendored guide in `third_party/rea/`. Never run `rea setup`.
5. If any hallucination tripwire fires or authorization is unclear: **STOP**, present findings, ask - never assume (kernel K1).
6. Finish with the Deep-tier adversarial self-audit (kernel K5): every claim tied to tool evidence, limits and unknowns stated.

If no request was given below, ask: "What is the target (file/app and version), what do you need to learn from it, and who owns it or authorized this analysis?"

User request: $ARGUMENTS
