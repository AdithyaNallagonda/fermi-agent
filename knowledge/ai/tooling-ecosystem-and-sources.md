# Tooling Ecosystem & Trusted Sources (MCP, plugins, skills, agents, extensions)
Last reviewed: 2026-10 — items marked [V] were verified on official pages on 2026-10-10 (code.claude.com docs,
registry.modelcontextprotocol.io, github.com/anthropics/skills). Re-verify install syntax before use ⚠️.
Load when: finding/installing tools via `instructions/capability-acquisition.md`.

## Where to look (trust order)
| Source | What | Notes |
|---|---|---|
| **Anthropic Directory** (claude.ai/directory) [V] | Reviewed remote connectors (MCP) | Any remote server listed there can be added with `claude mcp add` |
| **Anthropic official plugin marketplace** `claude-plugins-official` [V] | Plugins (skills, agents, hooks, MCP servers) | Added automatically on first interactive Claude Code start; browse via `/plugin` → Discover, or claude.com/marketplace/plugins; shows a **context cost** estimate |
| Other official-tier marketplace names [V] | e.g., `claude-code-plugins`, `anthropic-agent-skills`, `agent-skills`, `knowledge-work-plugins`, `claude-for-financial-services` | Claude Code accepts official/community names **only** when sourced from `github.com/anthropics/` |
| **Community tier** [V] | `claude-community`, `claude-plugins-community`, `healthcare` | Nearly every entry pinned to a commit SHA |
| **anthropics/skills** (GitHub) [V] | Agent Skills examples, spec, template; most Apache-2.0, document skills source-available | `/plugin marketplace add anthropics/skills` → `/plugin install document-skills@anthropic-agent-skills` or `example-skills@anthropic-agent-skills` |
| **Official MCP Registry** (registry.modelcontextprotocol.io) [V] | Metadata registry of public MCP servers (server.json; publisher namespace verification) | Built by MCP contributors; has an API; a listing ≠ a security review |
| Vendor-official MCP servers/extensions | e.g., cloud providers' and SaaS vendors' own repos (AWS, Microsoft, GitHub, Atlassian, etc.) | Confirm the GitHub org/publisher is really the vendor at time of use ⚠️ |
| VS Code Marketplace / Open VSX | Editor extensions | Prefer verified publishers; check activation events, permissions, telemetry |
| npm / PyPI / GitHub | Libraries, CLIs, scripts | Discovery only — full vetting required |

## Install / manage commands [V unless marked]
```bash
# MCP servers (scopes: local = ~/.claude.json, this project only [default]; project = .mcp.json (shared via VCS); user = ~/.claude.json, all projects)
claude mcp add --transport http <name> <url> [--scope local|project|user] [--header "Authorization: Bearer …"]
claude mcp add --transport stdio <name> --env KEY=VALUE -- <command> [args...]
claude mcp list
claude mcp get <name>
claude mcp remove <name>
/mcp                       # in-session panel: status, OAuth sign-in, toggle/reconnect, tool counts

# Plugins
/plugin                                   # browse Discover / Marketplaces / Installed tabs (details pane: "Will install")
/plugin marketplace add <owner/repo>
/plugin install <plugin>@<marketplace>
claude plugin marketplace list            # shows each marketplace's source
claude --plugin-dir <dir> plugin details <plugin>   # component inventory before install
claude plugin details <plugin>            # inventory of installed copy
claude plugin disable <plugin>
claude plugin uninstall <plugin> --scope <scope>
```
Standalone (no plugin needed): skills in `~/.claude/skills/<name>/SKILL.md` or `.claude/skills/`; subagents in
`~/.claude/agents/` or `.claude/agents/`; MCP via `claude mcp add`/`.mcp.json`; hooks in settings.

## Security facts to remember [V]
- "A Claude Code plugin you install can execute arbitrary code on your machine with your user privileges."
- Hooks, monitors, MCP/LSP server processes, and mod-started processes run **outside** Claude Code's sandbox with
  full user permissions; permission rules cover Claude's tool calls, not code a plugin runs by itself.
- Plugin `bin/` is added to the Bash tool's PATH. Skills/agents enter context as instructions (injection surface).
- Auto-update can change reviewed files — disable for third-party marketplaces after reviewing a version.
- Before install, read `hooks/hooks.json`, `.mcp.json`, every file in `bin/`.
- MCP docs: "Verify you trust each server before connecting it. Servers that fetch external content can expose you
  to prompt injection risk."
- Every enabled plugin's skill/agent descriptions cost context tokens on every turn — install only what's needed;
  disable when idle.

## Supply-chain vetting tools
OSV.dev / `osv-scanner`, `npm audit`, `pip-audit`, OpenSSF Scorecard, Socket.dev (package behavior analysis),
Mend SCA, GitHub Dependabot alerts, `trivy` for images; sigstore/cosign signature verification where offered.
