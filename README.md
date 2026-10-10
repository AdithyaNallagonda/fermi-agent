# Fermi — a modular Claude Code agent (principal architect)

A veteran solutions-architect / tutor / career-coach agent for **Claude Code (CLI)** and the **Claude
Code VS Code extension**. Use it to:

- turn rambling ideas into validated, monetizable apps with execution plans
- design systems from fundamentals to enterprise scale (AWS · Azure · GCP)
- review architectures, threat-model designs, and set up SSDLC (SAST/DAST/Mend/OWASP)
- design AI/LLM/RAG/agentic solutions and data platforms
- prepare for interviews (live mock interviews with scorecards) and certifications (verified study plans)
- plan delivery with Scrum/SAFe/PMP, and handle negotiations and workplace situations
- grow from senior engineer to Solution Architect in the Indian job market
- create **new agents** in the same modular pattern

## How it's organized

```
.claude/
  agents/fermi.md   ← the agent (persona + operating loop + routing)
  skills/<name>/SKILL.md          ← slash commands (thin pointers to playbooks)
  settings.json                   ← makes the agent the main thread when you open THIS folder
principles/                        ← governing principles (always-on rules)
instructions/                      ← playbooks: what to do, step by step (router: 00-request-router.md)
knowledge/                         ← one file per technology (router: INDEX.md)
templates/                         ← design doc, ADR, PRD/lean canvas, study plan, scorecard, threat model, agent
install-global.ps1                 ← install agent + skills to ~/.claude for every project
INSTALL.md                         ← installation guide, including the GitHub token steps
.env/                              ← your GitHub token (git-ignored, never committed; you create it)
```

The agent loads knowledge **on demand** (principles → playbook → only the relevant tech files), so
context stays small while depth stays large. Files with volatile facts are marked ⚠️ and the agent
verifies them live using the AWS docs, Microsoft Learn, and web tools when available.

## Using it

### Option A — inside this folder (zero setup)
Open this folder in VS Code (Claude extension) or run `claude` here. `.claude/settings.json` sets
`"agent": "fermi"`, so the whole session runs as the architect. Remove that line if you'd
rather have the default assistant and delegate to the agent only when needed.

### Option B — from any project (global install)
```powershell
cd "<path to this folder>"
.\install-global.ps1 -GrantReadAccess    # -Force to overwrite same-named skills, -Uninstall to remove
```
Then, in any project:
- **Run as the main agent**: `claude --agent fermi`
- **Delegate**: type `@` and pick *fermi*, or say "use the fermi agent to …"
- **Slash commands** (below)

The knowledge base stays in this folder; re-run the installer if you move it.

### You don't need commands — just ask
Describe what you want in plain words (even a ramble). The agent restates the ask, asks only the questions that
change the outcome (gate G0), announces its route (e.g., `Route: Debugging & RCA → root-cause-analysis.md`), loads
exactly the guides and knowledge that route needs from the Master Router, and works. Multi-part asks get a
numbered plan run in sequence.

### Slash commands (optional shortcuts)
The commands below skip intent detection when you already know the mode. They are user-only
(`disable-model-invocation: true`), so their descriptions don't consume context on every turn.

| Command | Purpose |
|---|---|
| `/idea-to-app <idea>` | Ramble → problem statement → MVP → architecture → backlog → roadmap |
| `/monetize <product>` | Value metric, pricing tiers, unit economics, GTM, India billing notes |
| `/design-system <system>` | Full system design with estimates, HLD, deep dives, cost, trade-offs |
| `/arch-review <path or design>` | Well-Architected review with prioritized findings |
| `/threat-model <design>` | STRIDE + OWASP (incl. LLM) threat model, SSDLC setup, scan triage |
| `/ai-solution <use case>` | LLM/RAG/agents/MCP design with guardrails, evals, token costs |
| `/data-platform <needs>` | Lakehouse/pipelines with Glue/EMR/Spark/Redshift and more |
| `/interview-prep <role>` or `mock <problem>` | Interview plan or live mock interview + scorecard |
| `/cert-plan <exam + date>` | Verified, tailored certification study plan |
| `/tutor <topic>` | Level-adaptive teaching with quizzes and flashcards |
| `/delivery-plan <project>` | Scrum/SAFe/PMP plans, PI planning kit, RAID, WSJF backlog |
| `/career-coach <profile>` | SA career roadmap (India), resume, negotiation, workplace situations |
| `/create-agent <purpose>` | Scaffold a new agent with its own modular knowledge base |
| `/ea <org + mandate>` | Enterprise architecture: capability maps, rationalization, target state, roadmap, governance |
| `/audit <artifact> [tier]` | Senior-reviewer adversarial audit of a plan, design, diff, document, research, or the agent's last answer |
| `/rca <symptom + context>` | Hawk-eye debugging & root cause analysis for code, network, DB, distributed systems, K8s, cloud, frontend, pipelines — asks for context, ranks hypotheses with evidence, runs discriminating checks, delivers a precise RCA |
| `/devops <platform + need>` | Platform-agnostic DevOps: CI/CD pipeline design and review, Terraform/OpenTofu, failure diagnosis for pipelines/plans/deployments, production release plans across environments |
| `/dba <engine+version + problem>` | Platform-agnostic DBA: tuning method, health checks, backup/PITR & DR, HA/replication, zero-downtime schema changes, upgrades, hardening, incidents (destructive steps gated) |
| `/ux-design <screen/flow/page>` | UI/UX design: research-lite, flows, wireframes → visual directions, tokens, accessible & performant prototypes |
| `/brand <product/company>` | Brand identity: strategy, naming (with real availability screening), SVG logo concepts, palette, type, voice |
| `/reverse-engineer <target + question>` | Reverse engineering of software you are authorized to analyze, with the opt-in REA tools: static first, evidence-backed, approval before anything runs |
| `/find-tools <need>` | Search the web for vetted MCP servers, plugins, skills, agents, prompts, extensions or scripts; shortlist with security scorecard; installs only with your approval |
| `/refresh-kb [area]` | Audit and update the knowledge base from official sources (certs, service lifecycle, versions, regulations) |

## Built-in adversarial self-audit
Every plan, decision, modification, build, research step and explanation is audited by the agent itself acting as
a **senior reviewer checking a junior's work** (`principles/adversarial-self-audit.md`, procedure in
`instructions/adversarial-audit.md`). It traces requirements to plan items, steelmans alternatives, re-reads
diffs, runs what it builds, verifies facts on primary sources, and labels claims as Verified / KB / Reasoned /
Memory. Depth scales Light → Standard → Deep with stakes, and each substantial answer ends with a
🔍 audit summary covering what was checked, what was fixed, and the remaining risk.

## Kernel + on-demand modules
Only the agent file (the **kernel**, ~2k tokens measured as chars÷4) is always in context. It holds the hallucination
guardrails, user gates, the audit rule, token rules, and a pointer to the **Master Router**
(`instructions/00-request-router.md`), which maps each kind of ask to its playbook, principle modules, knowledge
entry points and optional shortcut. Everything else loads on demand.

## Hallucination guardrails & user gates
Strict tripwires (untraceable fact, contradicting evidence, missing API/file, guessing, conflicting or
low-trust sources, outcome-changing ambiguity, discovering an earlier error) force a **⛔ Verification stop**:
the agent halts, shows the claim, the evidence and the impact, asks you targeted questions, and doesn't assume.
Planned gates: **G1** confirm requirements · **G2** high-impact decisions · **G3** unverifiable facts ·
**G4** irreversible actions. Questions come batched (≤ 4) with a recommended default.
Details: `principles/hallucination-guardrails-and-user-gates.md`.

## Capability acquisition (finding tools safely)
When a missing tool would help, the agent searches in trust order (Anthropic Directory and official
marketplaces → vendor-official servers → MCP Registry and curated community sources → general web, which is
for discovery only). It vets each candidate with a security scorecard covering publisher, source, maintenance,
permissions, install hooks, network calls, supply chain, license, prompt-injection risk, and context cost. It
reads any code that would run locally and presents a shortlist. It installs nothing without your explicit
approval (G4), and when it does install, it uses the narrowest scope with pinned versions.
See `instructions/capability-acquisition.md`.

## Audit trail: the `.docs/` folder
In any workspace where you call it, the agent keeps one folder per requirement under `.docs/`
(`.docs/YYYY-MM-DD-NN-<slug>/`). Each folder holds the ask record (your words, the restated intent, the route, and
your answers to its questions), the deliverables, the audit record, the sources, and a `scratch/` folder for every
intermediate file. A ledger at `.docs/INDEX.md` lists all asks. Long analysis is written once to that folder and the
chat gets a short summary with a link. Follow-ups reuse the same folder, so later sessions read the saved work
instead of regenerating it. Quick factual questions don't create a folder. Secrets are never written. Details:
`principles/workspace-docs.md`.

## Bundled tools
No desktop app is needed for the default set: only Node.js 20+ and a browser.

| Tool | What it gives the agent | Sign-in / setup |
|---|---|---|
| Azure DevOps MCP (Microsoft, `@azure-devops/mcp`) | Boards, repos, pull requests, pipelines, wiki, search | Browser sign-in with an account that can access your organization |
| GitHub MCP (GitHub's hosted server) | Repos, issues, pull requests, Actions, code search | A personal access token, stored once with `tools\set-github-token.ps1` |
| draw.io MCP (JGraph, `@drawio/mcp`) | Editable diagrams that open in draw.io in your browser | None |
| Mermaid CLI (`@mermaid-js/mermaid-cli`, via `tools\render-mermaid.ps1`) | Local validation and rendering of Mermaid diagrams | None |
| REA (`rea-agents`, third-party, **opt-in**) | Reverse engineering of software you are authorized to analyze | `-InstallRea`; Ghidra + JDK only for native binaries, JADX for Android |

- **In this folder**: the default servers come from `.mcp.json`. Set your Azure DevOps organization once with
  `setx ADO_ORG <your-org>`, store the GitHub token with `tools\set-github-token.ps1`, restart VS Code, then
  trust the folder and approve the servers when prompted (or run `/mcp`).
- **In every project**: `.\install-global.ps1 -GrantReadAccess -InstallMcpServers -AdoOrg <your-org>`.
  Without `-AdoOrg`, Azure DevOps is skipped. Servers you already have under the same name are left alone unless
  you add `-Force`. `-Uninstall` removes only what the script added.
- **GitHub token**: you create it in your own GitHub account; no script can do that step. In short: open the
  pre-filled link in [INSTALL.md](INSTALL.md#32-create-a-fine-grained-token), choose the repositories, generate
  the token, run `tools\set-github-token.ps1` in your own terminal, paste at the hidden prompt, then reconnect
  `github` from `/mcp`. `-VerifyOnly` re-checks the stored token; `-Remove` deletes it. Full steps, the
  permission table, troubleshooting, and setup on other machines: [INSTALL.md](INSTALL.md).
- **Where the token lives**: only in `.env/github.token` in this folder, which git ignores. No configuration
  file or environment variable holds it; `.mcp.json` points to `tools/github-mcp-headers.mjs`, which hands the
  token to GitHub's server only. A commit hook, a `Read` deny rule for Claude's file tools and the `.gitignore`
  keep it from being committed or read ([INSTALL.md §3.8](INSTALL.md#38-how-the-token-is-kept-inside-this-folder)).
- **REA is opt-in** (`.\install-global.ps1 -InstallRea`) because it is a powerful third-party tool with a
  single maintainer. The agent asks who owns the target and why before analysing, works statically first, and
  asks before anything runs a target program. Its workflow guide is vendored unmodified in `third_party/rea/`.
- Write actions in Azure DevOps and GitHub (work items, issues, PRs, pipeline runs, wiki pages) always ask you
  first.
- Versions are pinned. Details, data handling and usage: `knowledge/ai/bundled-tools.md`.

## Token efficiency
`principles/token-efficiency.md` makes the agent spend the minimum tokens that still give a correct, verified
result: no reloading files already in context, keyword search over the index instead of full reads, section-level
loading, cheapest-sufficient research path, batched tool calls, minimal diffs, length budgets per request type, and
right-sized audits. A quality floor (requirement coverage, fact verification, Blocker fixes, security, residual
risk) is never trimmed.

## Extending the knowledge base
1. Add `knowledge/<area>/<technology>.md` using `templates/knowledge-file-template.md`.
2. Register it in `knowledge/INDEX.md`.
3. New task types: add a playbook in `instructions/` and a row in `instructions/00-request-router.md`;
   optionally add a skill in `.claude/skills/`.
4. Re-run `install-global.ps1` only if you changed the agent or skills (knowledge is read live).

## Keeping it current
Every knowledge file has a `Last reviewed` date and states the source it was verified against. Run
`/refresh-kb` quarterly (monthly for certifications during announced exam transitions). It follows
`instructions/kb-refresh.md`: primary sources first (AWS/Microsoft docs MCPs, official cert pages, PMI PDFs,
regulators), blogs only for discovery, then it greps and fixes every stale reference and reports what changed.
