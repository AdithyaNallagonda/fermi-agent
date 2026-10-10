# Master Router (single source of truth for routing)

The agent routes every ask itself — users never need slash commands (they're optional shortcuts).
**Token tip:** Grep this file for the ask's keywords and read only the matching rows + the protocol below.

## Intent-resolution protocol (Gate G0 — before any work)
1. **Understand**: restate the ask in one line (what outcome the user wants, for whom, by when, in what form).
2. **Classify**: match signals below → candidate mode(s). Rambling or multi-part asks often map to 2–4 modes.
3. **Clarify only if needed**: if the mode is ambiguous *or* a missing fact changes the route/outcome, ask ≤ 4
   questions with options (recommended first). Don't ask what the router, the workspace, or a tool can answer.
4. **Announce the route** in one line before working, e.g. `Route: Debugging & RCA → root-cause-analysis.md
   (+ DBA lens)`. For multi-mode asks: `Plan: (1) Idea → execution, (2) Monetization, (3) Brand` — then run in order,
   carrying context forward (don't re-ask what earlier passes settled).
5. **Load** only that row's playbook + principle modules + knowledge entry points (skip what's in context; open
   more knowledge via `knowledge/INDEX.md` only when the playbook needs it). Then follow the playbook's gates.
6. **Re-route** if the conversation shifts (e.g., a design discussion turns into a production bug → RCA).
Quick factual questions / clarifications: answer from the kernel + one KB file or a verified source — no playbook.

## Route table
| Signals in the ask | Mode | Playbook (`instructions/`) | Principle modules (`principles/`) | Knowledge entry points (`knowledge/`) | Shortcut |
|---|---|---|---|---|---|
| "design X", "how would you build", HLD/LLD, scale, architecture, trade-offs | System design | `system-design.md` | `00-core-principles.md`, `architecture-principles.md`, `output-standards.md` (+ `security-principles.md` if regulated/AI) | `fundamentals/system-design-fundamentals.md`, `databases/database-selection.md`, cloud file | `/design-system` |
| Rambling idea, "I want to build an app that…", "turn this into a plan", MVP | Idea → execution | `idea-to-execution.md` | `00-core-principles.md`, `delivery-principles.md`, `output-standards.md` | `business/entrepreneurship-and-idea-validation.md` | `/idea-to-app` |
| Make money, pricing, GTM, startup, SaaS revenue, side income | Monetization | `monetization-and-gtm.md` | `ethics-and-boundaries.md` | `business/saas-monetization-and-pricing.md` | `/monetize` |
| LLM, RAG, agents, MCP (building), vector DB, fine-tuning, AI app | AI solution | `ai-solution-design.md` | `00-core-principles.md`, `architecture-principles.md`, `security-principles.md` | `ai/rag-architecture.md`, `ai/cloud-ai-platforms.md`, `security/ai-security.md` | `/ai-solution` |
| ETL/ELT, Glue, EMR, Spark, lakehouse, warehouse, streaming pipeline | Data platform | `data-platform-design.md` | `00-core-principles.md`, `architecture-principles.md` | `data-engineering/lakehouse-and-table-formats.md`, engine files | `/data-platform` |
| Angular/React architecture, frontend system design, web performance | Frontend architecture | `frontend-architecture.md` | `architecture-principles.md` | `frontend/frontend-system-design.md`, `frontend/web-performance-and-security.md` | — |
| UI/UX, wireframe, mockup, landing/web page, dashboard design, usability, a11y review, design system | UI/UX design | `ux-ui-design.md` | `design-principles.md` | `design/ux-research-and-interaction.md`, `design/ui-visual-and-design-systems.md`, `design/accessibility.md` | `/ux-design` |
| Logo, brand identity, naming a product/company, tagline, palette, brand voice | Brand identity | `brand-identity.md` | `design-principles.md`, `ethics-and-boundaries.md` | `design/branding-logo-and-naming.md`, `design/design-trends.md` | `/brand` |
| Bug, error, outage, intermittent failure, "why is X happening", incident, RCA, postmortem (any layer) | Debugging & RCA | `root-cause-analysis.md` | `diagnostic-reasoning.md`, `hallucination-guardrails-and-user-gates.md` | `fundamentals/failure-modes-and-bug-patterns.md` + domain file | `/rca` |
| CI/CD pipeline design or review, GitHub Actions / Azure Pipelines / GitLab CI / Jenkins, Terraform/OpenTofu/IaC, state, drift, failed pipeline/plan/apply/deploy, release or rollout plan, multi-environment promotion | DevOps engineering | `devops-engineering.md` | `devops-principles.md` (+ `security-principles.md` for pipeline security; `diagnostic-reasoning.md` for failures) | `devops/cicd-pipeline-design.md`, `devops/terraform-deep-dive.md`, `devops/pipeline-and-iac-failure-modes.md`, `devops/multi-environment-deployment.md` | `/devops` |
| Slow query, DB tuning, deadlocks, replication lag, backup/restore, failover, DB upgrade/migration, DB health check | DBA operations | `dba-operations.md` | `dba-principles.md` (+ `security-principles.md` for hardening) | `databases/dba-fundamentals.md`, `databases/dba-diagnostics-cheatsheet.md`, engine file | `/dba` |
| Reverse engineer / decompile / "how does this binary, app, bundle, APK work" / legacy system without source / malware triage | Reverse engineering | `reverse-engineering.md` | `security-principles.md`, `ethics-and-boundaries.md`, `diagnostic-reasoning.md`, `hallucination-guardrails-and-user-gates.md` | `ai/bundled-tools.md` (REA), vendored guide in `third_party/rea/` | `/reverse-engineer` |
| Threat model, SSDLC, SAST/DAST/Mend, OWASP, pentest findings, compliance controls | Security | `security-review.md` | `security-principles.md` | `security/ssdlc.md`, `security/owasp.md` | `/threat-model` |
| Review/critique my design/code/diagram, "what's wrong with" (architecture lens) | Architecture review | `architecture-review.md` | `architecture-principles.md`, `adversarial-self-audit.md`, `quality-gates.md` | per artifact | `/arch-review` |
| "audit / poke holes / red-team this plan/doc/answer", "is this right?" | Adversarial audit | `adversarial-audit.md` | `adversarial-self-audit.md`, `quality-gates.md` | per artifact | `/audit` |
| EA, target state, capability map, app rationalization, landing zone, governance, ARB, M&A IT, multi-tenant SaaS strategy | Enterprise architecture | `enterprise-architecture.md` | `00-core-principles.md`, `architecture-principles.md`, `security-principles.md`, `delivery-principles.md` | `enterprise/enterprise-architecture-practice.md`, other `enterprise/*` | `/ea` |
| Sprint, PI planning, roadmap, estimates, RAID, PMP/SAFe process, status report | Delivery | `project-delivery.md` | `delivery-principles.md` | `delivery/scrum-and-agile.md`, `delivery/safe.md`, `delivery/pmp-and-project-management.md` | `/delivery-plan` |
| "Explain", "teach me", "I don't understand", ELI5, concept deep-dive | Tutoring | `tutoring-session.md` | `tutoring-principles.md` | topic file via INDEX | `/tutor` |
| Interview, mock, "how do I answer", system design interview | Interview prep | `interview-prep.md` | `tutoring-principles.md`, `communication-and-soft-skills.md` | `fundamentals/classic-design-problems.md` | `/interview-prep` |
| Certification, exam code (SAA-C03, AZ-305, PMP…), study plan | Certification | `certification-coaching.md` | `tutoring-principles.md`, `ethics-and-boundaries.md` | `certifications/<provider>.md` | `/cert-plan` |
| Career move, resume, SA role, salary, India job market | Career | `career-coaching.md` | `communication-and-soft-skills.md`, `ethics-and-boundaries.md` | `career/india-solution-architect-market.md` | `/career-coach` |
| Manager/peer conflict, negotiation, hike, escalation, politics | Corporate situations | `corporate-situations.md` | `communication-and-soft-skills.md`, `ethics-and-boundaries.md` | `career/corporate-navigation-and-negotiation.md` | `/career-coach` |
| "Find/install a tool, MCP server, plugin, skill, extension, script", or a capability gap mid-task | Capability acquisition | `capability-acquisition.md` | `security-principles.md`, `hallucination-guardrails-and-user-gates.md` | `ai/bundled-tools.md` (already shipped), `ai/tooling-ecosystem-and-sources.md` | `/find-tools` |
| "Create an agent/subagent/skill for…" | Agent factory | `agent-factory.md` | `token-efficiency.md` | `ai/agentic-systems-and-mcp.md` | `/create-agent` |
| "Update/refresh/audit your knowledge base", "is this still current?" | KB refresh | `kb-refresh.md` | `token-efficiency.md`, `adversarial-self-audit.md` | `INDEX.md` (⚠️ files) | `/refresh-kb` |

## Cross-cutting (apply in every mode, per the kernel)
Hallucination tripwires & STOP (K1) · user gates G0–G4 (K2) · adversarial self-audit at the right tier (K5) —
every mode ends with it; the tier decides whether to load `adversarial-audit.md` · token discipline (K6) ·
workspace docs — per-ask folder under `.docs/` + lean chat reporting (K7, `workspace-docs.md`) ·
capability acquisition when a tool gap blocks progress (K6a). Standard/Deep audits add `adversarial-self-audit.md`;
tripwires add `hallucination-guardrails-and-user-gates.md`.

## Bundled tools (any mode)
Azure DevOps and GitHub data (boards/issues, repos, PRs, pipelines/Actions, wiki), editable diagrams (draw.io),
Mermaid validation/rendering and — opt-in — REA reverse-engineering tools are already available — see `knowledge/ai/bundled-tools.md` before searching for other tools.

## Common multi-mode sequences
- Rambling startup idea → Idea → execution → Monetization → Brand → (optional) System design / UI/UX.
- "Prod is slow after migration" → Debugging & RCA (DBA lens) → DBA operations for the fix.
- "The deploy pipeline failed / terraform apply broke" → DevOps engineering track C (uses the RCA playbook with
  the DevOps failure catalog) → fix → guard.
- New product going live → System design → DevOps engineering (pipeline + IaC) → Security (threat model) →
  DevOps track D (release runbook).
- "Prepare me for an SA role" → Career → Certification → Interview prep (shared intake; one combined plan).
- "Build an AI app for enterprise" → AI solution → Security (threat model) → Enterprise (landing zone/regulatory).
