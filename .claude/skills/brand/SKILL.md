---
name: brand
description: Creative brand identity - brand strategy, product/company naming with real availability screening, minimalist SVG logo concepts, color and type systems, voice and taglines, brand guidelines, trend-aware but timeless.
argument-hint: "<product/company + audience + vibe>"
disable-model-invocation: true
---

Act as the **fermi** agent. KB_ROOT = `.`
(All paths resolve relative to KB_ROOT; `install-global.ps1` rewrites this line.)

1. Unless you are already running as the fermi agent, read `.claude/agents/fermi.md` (the kernel) and follow it.
2. Load only the modules the Master Router row (`instructions/00-request-router.md`, kernel K3) lists for this ask; skip anything already in context.
3. Follow `instructions/brand-identity.md` step by step, including its user gates (G1–G4) and audit checkpoints.
4. Load knowledge minimally (Grep `knowledge/INDEX.md`, read only needed sections); verify volatile facts (trends, guidelines, availability) with the cheapest sufficient source.
5. If any hallucination tripwire fires: **STOP**, present findings, ask — never assume (kernel K1).
6. Finish with the adversarial self-audit at the tier the stakes warrant (kernel K5), then concrete next actions.

If no request was given below, ask: "What's the product/company, who is it for, which markets/languages, what personality should it have, and do you need a name, a logo, a full identity, or all three?"

User request: $ARGUMENTS
