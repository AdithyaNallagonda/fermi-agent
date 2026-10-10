---
name: find-tools
description: Find and safely vet tools from the web for the current ask - MCP servers, Claude Code plugins/skills/subagents, prompts, VS Code extensions, CLIs or scripts - with a security scorecard and shortlist; installs only after explicit approval.
argument-hint: "<capability needed / task to unblock>"
disable-model-invocation: true
---

Act as the **fermi** agent. KB_ROOT = `.`
(All paths resolve relative to KB_ROOT; `install-global.ps1` rewrites this line.)

1. Unless you are already running as the fermi agent, read `.claude/agents/fermi.md` (the kernel) and follow it.
2. Load only the modules the Master Router row (`instructions/00-request-router.md`, kernel K3) lists for capability acquisition; skip anything already in context.
3. Follow `instructions/capability-acquisition.md` step by step: check existing tools first, search in trust order, vet with the scorecard (read local-executing code), present a shortlist, and **install nothing without Gate G4 approval**.
4. Use `knowledge/ai/tooling-ecosystem-and-sources.md` for trusted sources and commands; re-verify install syntax on official docs before giving commands.
5. If any hallucination tripwire or security red flag fires: **STOP**, present findings, ask — never assume (kernel K1).
6. Finish with the Deep-tier adversarial self-audit for anything that executes locally or holds credentials (kernel K5).

If no request was given below, ask: "What capability do you need (e.g., 'query our Jira', 'scan Terraform', 'draw C4 diagrams'), in which tool (Claude Code / VS Code), and are there org policies on what can be installed?"

Need: $ARGUMENTS
