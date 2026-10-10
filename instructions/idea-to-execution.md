# Playbook: Rambling Idea → Actionable Execution Plan

Knowledge: `knowledge/business/*`, `knowledge/delivery/*`, plus tech files as the design emerges.
Templates: `templates/lean-canvas-prd.md`, `templates/design-doc.md`, `templates/epic-feature-story.md`.

## Step 1 — Extract signal from the ramble
Parse the user's text into buckets (show this back as a table):
| Bucket | What I heard |
|---|---|
| Problem / pain | |
| Target user(s) | |
| Proposed solution / features | |
| Constraints (time, money, skills, platform) | |
| Monetization hints | |
| Unknowns / contradictions | |

Then write a **one-sentence problem statement** and **one-sentence value proposition**:
"For <user> who <pain>, <product> is a <category> that <key benefit>. Unlike <alternative>, we <differentiator>."

**Gate G1**: present the bucket table + problem statement and ask (≤ 4 questions, recommended defaults) only what
changes the plan; wait for confirmation. If the user waived questions, list assumptions as **[Assumed: …]**.

## Step 2 — Validate before building
- Market gap check: who solves this today (competitors, spreadsheets, manual work)? Why now?
- Riskiest assumption test (RAT): what must be true? Cheapest experiment to test it (landing page,
  concierge MVP, Wizard-of-Oz, pre-sales, interviews with 10–15 target users).
- See `knowledge/business/entrepreneurship-and-idea-validation.md`.

## Step 3 — Scope the MVP
- MoSCoW the feature list; MVP = Must-haves that test the core value hypothesis.
- User journey map for the primary persona (happy path only for MVP).
- Non-functional baseline: auth, security scans, backups, analytics, error tracking — always in MVP.

## Step 4 — Architecture right-sized for stage
| Stage | Default architecture |
|---|---|
| Prototype (days) | Single repo, serverless/BaaS (Supabase/Firebase/Amplify), managed auth, Postgres |
| MVP (weeks) | Modular monolith, managed Postgres, Redis optional, object storage, CDN, CI/CD, IaC |
| Growth | Extract services on clear seams, queues, read replicas, search, observability stack |
| Scale/enterprise | Multi-account landing zone, multi-region DR, data platform, platform team |
Run `instructions/system-design.md` at the depth matching the stage. Include AI features via
`instructions/ai-solution-design.md` if relevant.

## Step 5 — Execution plan
- **Roadmap**: phases (Discover → MVP → Beta → GA → Scale) as Mermaid Gantt with week estimates.
- **Backlog**: Epics → Features → Stories with acceptance criteria (Given/When/Then); WSJF-ranked.
- **Team & roles**: solo / 2–3 / squad; skill gaps and how to fill them.
- **Cost**: monthly infra estimate at 100 / 10k / 100k users; tools/SaaS costs.
- **Risks**: ROAM table.
- **Week-1 action list**: 5–10 concrete tasks.

> **Audit checkpoint (A + B) — before handing off or persisting:** trace every requirement from the user's
> original ramble → MVP scope/backlog/roadmap and back; sanity-check estimates and costs; fix Blockers now.

## Step 6 — Monetization & launch
Hand off to `instructions/monetization-and-gtm.md`.

## Step 7 — Persist
Write `PRD.md`, `architecture.md`, `backlog.md` (and ADR drafts) into this ask's `.docs/` folder; chat gets the
TL;DR + links. Offer to promote any of them into the project proper (`docs/…`, after G4).

## Final step — Adversarial audit (mandatory)
Follow `instructions/adversarial-audit.md` as the senior reviewer of this work. Tier: **Standard**.
Apply: A (MVP scope, roadmap, backlog — full requirement → plan traceability against the user's ORIGINAL ramble, not your summary), B (stage architecture + build/buy), E (market/competitor/pricing claims). Fix Blockers before presenting; end with the 🔍 audit summary
(`principles/adversarial-self-audit.md`).
