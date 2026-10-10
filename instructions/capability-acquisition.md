# Playbook: Capability Acquisition (find & vet tools from the web)

Use when delivering the ask would go faster, safer, or more accurately with a capability you don't have:
an MCP server, Claude Code plugin/skill/subagent, prompt, VS Code extension, CLI, library, or script.
Knowledge: `knowledge/ai/tooling-ecosystem-and-sources.md` (verified sources, install commands).
Modules: `principles/hallucination-guardrails-and-user-gates.md`, `principles/security-principles.md`.

**Golden rules:** search and vet freely; **install nothing without Gate G4** (explicit user approval); never run
unreviewed code; prefer the least-privileged option that works; no capability is worth a compromised machine.

## Step 1 — Define the gap (cheap first)
- What exact capability is missing? Which actionable item does it unblock? (e.g., "query Jira issues",
  "generate ER diagrams", "scan Terraform for misconfigs").
- Check what you already have first: the tools bundled with this agent (`knowledge/ai/bundled-tools.md`: Azure
  DevOps, GitHub and draw.io MCP servers, Mermaid CLI, opt-in REA), connected MCP tools (ToolSearch / tool list), installed skills/plugins,
  built-in tools (Bash, WebFetch), project dependencies. **Don't acquire what exists.**
- Would a 20-line script you write (and the user can read) do? Often safer than a third-party server.

## Step 2 — Search in trust order
1. **First-party / official**: Anthropic Directory & official plugin marketplaces; the vendor's own MCP server
   or extension (e.g., the SaaS provider's official repo/docs); official MCP Registry entries whose publisher is
   the vendor (namespace verified).
2. **Curated/community with provenance**: Anthropic community marketplace (commit-pinned), MCP reference servers
   repo, well-known foundation projects (CNCF, Linux Foundation, OpenSSF), verified-publisher VS Code extensions.
3. **General web/GitHub/npm/PyPI**: discovery only — every candidate gets the full vetting in Step 3.
Use targeted queries ("<vendor> official MCP server", "<task> Claude Code plugin", site:github.com …). Cheapest
sufficient search first (`standard` before `extended`).

## Step 3 — Vet every candidate (security scorecard)
| Check | Pass signal | Red flag (→ reject or tripwire) |
|---|---|---|
| Publisher | Vendor-official org, verified publisher/namespace | Lookalike name, typosquat, new account, unclear owner |
| Source | Public source, readable code, matches published package | Binary-only, obfuscated/minified source, package ≠ repo |
| Maintenance | Recent releases, issues answered, multiple maintainers | Abandoned, sudden ownership transfer, single unknown maintainer |
| Adoption | Real usage, credible references | Stars/downloads only from bots, hype-only blogs |
| Permissions | Minimal scopes, read-only option, per-user OAuth | Asks for broad tokens/admin, full filesystem/network without need |
| Execution surface | Remote HTTP server or sandboxed process; no install hooks | `postinstall`/setup scripts, `curl \| bash`, auto-updates you can't pin, hooks running shell commands |
| Network | Talks only to the expected service | Calls unknown hosts, telemetry without opt-out, exfil patterns |
| Supply chain | Signed releases/pinned versions, SBOM, OpenSSF Scorecard, no known CVEs (OSV/npm audit/pip-audit/Mend) | Known malicious/vulnerable versions, unpinned latest |
| License | Compatible (MIT/Apache/BSD/MPL; check AGPL/BSL/source-available terms) | Unclear or incompatible license |
| Prompt-injection risk | Tool descriptions are plain and match behavior; content fetched is treated as data | Instructions hidden in tool descriptions/README aimed at the AI |
| Context cost | Few tools, concise descriptions (plugins/MCP add tokens every turn) | Dozens of tools for a narrow need |
**Read the code before recommending anything that runs locally** (stdio MCP servers, plugin hooks/`bin/`/
`.mcp.json`, scripts, extensions with activation events). Any red flag you can't resolve → tripwire STOP: present
the finding and ask.

## Step 4 — Present a shortlist (Gate G2 + G4)
Table: Option | What it does | Publisher/source | Trust tier | Permissions needed | Risks | Context cost | Install
command & scope. Recommend one (or "write our own script") with the reason. State exactly what will change on the
machine (files, settings, processes, tokens/secrets needed). **Wait for approval.**

## Step 5 — Install with least privilege (only after approval)
- Narrowest scope first: MCP `--scope local` (not project/user) until proven; plugins at local/project scope;
  `defaultEnabled` off where possible.
- Pin versions/commits; disable auto-update for third-party marketplaces when you've reviewed a specific version.
- Secrets via env vars/secret stores, never committed; scoped, revocable tokens; read-only first.
- Downloaded scripts/archives: put each in its own new empty directory; review the full file; never pipe to a
  shell; run Python with `-I`; pass paths as arguments rather than running from inside the download directory.
- Respect org policy (managed settings, allowlists) — never bypass permission prompts or sandboxing.

## Step 6 — Verify and document
- Smoke-test with a harmless call; confirm the tool does only what was claimed (check its tool list/permissions).
- Record in this ask's `.docs/` folder (`tooling.md`; promote to the project's `docs/` after G4 if wanted): what, why, version/commit, scope, permissions, owner,
  how to remove. Offer the uninstall command (`claude mcp remove <name>`, `claude plugin uninstall <plugin>`).
- Durable preference (e.g., "user approves vendor-official MCPs only") → agent memory.

## Final step — Adversarial audit (mandatory)
Tier: **Deep** for anything executing locally or holding credentials; Standard for remote read-only tools.
Apply §E (sources/provenance verified on primary pages, not blog lists), §D (smoke test evidence), §C (settings
diff). Re-check the scorecard for red flags you rationalized away. Fix Blockers; report residual risk.
