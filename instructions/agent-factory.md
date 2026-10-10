# Playbook: Creating New Agents

Use this to help the user create new Claude Code agents (subagents + skills) — or AI agents for their
products (then also load `knowledge/ai/agentic-systems-and-mcp.md`).

## A. Claude Code agent (same modular pattern as this one)
1. **Define the job** — purpose, users, top 5 tasks, inputs/outputs, tools needed, what it must
   never do. Narrow, focused agents outperform generalists for delegation.
2. **Choose scope** — project (`<repo>/.claude/agents/`) or user-global (`~/.claude/agents/`).
3. **Scaffold** (mirror this repo):
   ```
   <agent-root>/
     .claude/agents/<name>.md          # KERNEL: identity, guardrails, gates, self-routing pointer, loop (keep ~2k tokens)
     instructions/00-request-router.md  # MASTER ROUTER: signals → playbook → modules → knowledge → shortcut
     .claude/skills/<skill>/SKILL.md   # optional slash commands
     principles/00-core-principles.md
     principles/adversarial-self-audit.md   # copy from this repo — every agent audits its own work
     principles/hallucination-guardrails-and-user-gates.md  # copy — STOP protocol + user gates
     principles/token-efficiency.md         # copy — minimum tokens without lowering quality
     principles/workspace-docs.md           # copy — per-ask `.docs/` audit trail + lean chat reporting
     instructions/00-request-router.md + <playbooks>.md
     knowledge/INDEX.md + <domain>/<tech>.md
     templates/
     CLAUDE.md
   ```
4. **Write the agent file** from `templates/agent-template.md`:
   - `name`: kebab-case, unique.
   - `description`: *when to use it* — the main thread uses this to decide delegation; include
     trigger phrases.
   - `tools`: omit to inherit all; or restrict (e.g., `Read, Grep, Glob` for read-only reviewers).
   - `model`: `inherit`, `sonnet`, `opus`, `haiku`.
   - Body: identity, operating loop, routing to files, output format, boundaries.
5. **Skills** (`.claude/skills/<name>/SKILL.md`) for user-invoked entry points (`/name args`); use
   `$ARGUMENTS` for the user's text. Keep each skill a thin pointer to a playbook.
6. **Knowledge** — one file per technology; INDEX with "load when" column; progressive disclosure.
7. **Test** — run 5 representative prompts; check routing, file loading, output quality; iterate on
   the description and router.
7a. **Audit checkpoint (D + C) — before installing:** parse frontmatter, check every referenced path exists,
   dry-run the router on the 5 test prompts, confirm the new agent carries an adversarial self-audit rule.
8. **Gate G4**, then **Install** — copy to `~/.claude` (see `install-global.ps1` pattern) for global availability.

## B. Product AI agents (for the user's apps)
Follow `instructions/ai-solution-design.md` + agentic knowledge: tool design, MCP servers, memory,
guardrails, evals, HITL, cost budgets, observability.

## Final step — Adversarial audit (mandatory)
Follow `instructions/adversarial-audit.md` as the senior reviewer of this work. Tier: **Deep**.
Apply: D (frontmatter parses, referenced files exist, skills invoke correctly, tools scoped), C (router/INDEX updated), confirm the new agent itself includes an adversarial self-audit principle. Fix Blockers before presenting; end with the 🔍 audit summary
(`principles/adversarial-self-audit.md`).
