# Fermi Agent — Project Guide

This repository **is** an agent: a modular knowledge base plus operating instructions for the
`fermi` Claude Code subagent (`.claude/agents/fermi.md`).

## Layout
- `.claude/agents/fermi.md` — agent entry point (persona + operating loop)
- `.claude/skills/*/SKILL.md` — slash commands (`/design-system`, `/idea-to-app`, `/interview-prep`, …)
- `principles/` — governing principles (always-on rules)
- `instructions/` — playbooks (how to do each type of task); start at `00-request-router.md`
- `knowledge/` — one file per technology/domain; start at `knowledge/INDEX.md`
- `templates/` — output skeletons
- `.mcp.json` — bundled MCP servers at project scope (Azure DevOps, draw.io, GitHub), versions pinned; single source of
  truth that `install-global.ps1 -InstallMcpServers` registers at user scope
- `mcp-optional.json` — opt-in MCP servers (REA reverse engineering), registered only by `install-global.ps1 -InstallRea`
- `third_party/` — vendored third-party guidance, unmodified, with license and source (`third_party/rea/`)
- `tools/` — helper scripts (`render-mermaid.ps1`: local Mermaid validate/render; `set-github-token.ps1`:
  stores the GitHub token in `.env/github.token` without echoing it; `github-mcp-headers.mjs`: the
  `headersHelper` that gives that token to GitHub's MCP server only; `git-hooks/pre-commit`: blocks commits
  that contain a token)
- `.env/` — local secrets (the GitHub token). Git-ignored and denied to Claude's file tools in
  `.claude/settings.json`. **Never read it, print it, commit it, or copy it anywhere**
- `install-global.ps1` — installs the agent + skills to `~/.claude` for use in any project
- `INSTALL.md` — installation guide for people and agents, including the GitHub token steps; keep it in sync
  with `.mcp.json`, the installer switches and `tools/set-github-token.ps1`

## Conventions when editing this repo
- One technology per knowledge file. Use `templates/knowledge-file-template.md`.
- Every new knowledge file must be registered in `knowledge/INDEX.md`.
- Every new playbook must be registered in `instructions/00-request-router.md`.
- Put a `Last reviewed: YYYY-MM` line at the top of knowledge files; mark volatile facts with ⚠️.
- Keep files dense: decision tables, numbers, gotchas, interview angles. No filler prose.
- Paths inside agent/skills/instructions are relative to KB_ROOT (repo root).
- **Kernel + modules**: only the agent file (kernel) is always loaded. Every principle is a module loaded via the
  Master Router (`instructions/00-request-router.md`) — the single routing table (signals → playbook → modules →
  knowledge entry points → shortcut). Add a row there for every new mode/module; the kernel only points to it.
- Skills are user-only shortcuts (`disable-model-invocation: true`) so their descriptions cost no tokens per turn;
  the agent self-routes via the router. Keep that flag on new skills.
- Keep the kernel short; anything long must be loadable by
  section. Measure size impact (chars/4 ≈ tokens) when adding to them (`principles/token-efficiency.md`).
- **Workspace docs**: in any workspace the agent keeps one folder per ask under `.docs/` (ask record,
  deliverables, audit, sources, `scratch/` for intermediates) and reports long analysis as file + terse chat
  summary (`principles/workspace-docs.md`). Playbooks should write deliverables there, not to the project root.
- Never commit secrets: MCP configs hold no tokens (a `headersHelper` or a `${VAR}` reference only). `.env/`
  and `.docs/` stay local (`.gitignore`); keep `core.hooksPath` set to `tools/git-hooks`. Changes reach the
  public repository through pull requests to `main`. Third-party text in `third_party/` is
  reference material; this repo's playbooks and gates take precedence over it.
- Bundled tools are pinned and vetted (`knowledge/ai/bundled-tools.md`). Re-vet (publisher, install hooks,
  changelog) before bumping a version in `.mcp.json` or `tools/`; never add an unvetted server.
- Every playbook ends with a mandatory adversarial-audit step and has an audit checkpoint before any
  irreversible step (writing deliverables, installing, editing the KB). New playbooks/skills must do the same
  (`principles/adversarial-self-audit.md`, `instructions/adversarial-audit.md`).
