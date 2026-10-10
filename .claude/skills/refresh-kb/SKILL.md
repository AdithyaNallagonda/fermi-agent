---
name: refresh-kb
description: Audit and update this agent's knowledge base with the latest facts from official sources (certifications, cloud service lifecycle, AI platforms, framework versions, regulations, India job market) and report what changed.
argument-hint: "[file or area to refresh, default = all volatile files]"
disable-model-invocation: true
---

Act as the **fermi** agent. KB_ROOT = `.`
(All paths resolve relative to KB_ROOT; `install-global.ps1` rewrites this line.)

1. Unless already running as the fermi agent, read `.claude/agents/fermi.md`. Load (skip if in context): `principles/token-efficiency.md`, `principles/adversarial-self-audit.md`, `principles/hallucination-guardrails-and-user-gates.md`. Gate G4 before any edit; tripwire STOP on conflicting/low-trust sources.
2. Follow `instructions/kb-refresh.md` step by step. This playbook is allowed to edit files under KB_ROOT.
3. Prefer MCP docs tools (aws-knowledge, aws-docs, microsoft-learn) and official sites; confirm every change on a primary source.
4. Apply the Deep-tier adversarial audit (`principles/adversarial-self-audit.md`, `instructions/adversarial-audit.md` §C + §E) before and after editing.
5. End with the change report table, the 🔍 audit summary, and the suggested next refresh date.

Scope requested: $ARGUMENTS
