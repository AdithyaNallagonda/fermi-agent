# Playbook: Enterprise Architecture Engagement

Knowledge: `knowledge/enterprise/*` (start with `enterprise-architecture-practice.md`), plus
`cloud/well-architected-and-finops.md`, `security/cloud-security.md`, `data-engineering/lakehouse-and-table-formats.md`.
Templates: `templates/adr.md`, `templates/design-doc.md`.

## Step 1 — Frame the mandate
Strategy & drivers (growth, cost, M&A, regulation, AI), scope (business units, geographies), stakeholders &
decision rights, time horizon (12–36 months), constraints (budget, regulators, contracts, skills).

**Gate G1**: confirm mandate, scope, horizon and decision rights before baselining.

## Step 2 — Baseline (current state)
- Business capability map (L1–L2) with heat map: strategic importance × maturity × cost × risk.
- Application & technology portfolio: inventory, owners, cost, lifecycle/EOL, redundancy per capability,
  integration map, data classification. Flag lifecycle risks (maintenance/sunset services, EOL runtimes).
- Cloud foundation maturity (`enterprise/landing-zones-and-cloud-governance.md`), platform maturity
  (`enterprise/platform-engineering.md` CNCF model), data governance maturity (`enterprise/data-governance.md`),
  security posture, regulatory obligations (`enterprise/regulatory-architecture.md`).

## Step 3 — Target state
Principles (5–12, with rationale & implications) → target business/data/application/technology architecture →
reference architectures & paved roads (incl. AI platform, multi-tenant SaaS if relevant:
`enterprise/multi-tenant-saas-architecture.md`) → integration strategy (`enterprise/integration-architecture.md`).

## Step 4 — Gap analysis & portfolio dispositions
Gaps per capability; TIME + 7Rs dispositions; build/buy/reuse decisions recorded as ADRs.

## Step 5 — Roadmap
Transition architectures (e.g., T1 foundation → T2 core migrations → T3 differentiation/AI), sequenced by value,
risk, dependencies and funding cycle; Mermaid Gantt; quick wins in the first 90 days; benefits case (cost savings,
risk reduction, speed, revenue enablement).

## Step 6 — Governance & operating model
Federated EA model, ARB charter with SLA, guardrails-as-code, exception process, architecture KPIs, alignment to
SAFe/portfolio funding (see `delivery/safe.md`).

> **Audit checkpoint (A + B, Deep) — before communicating:** roadmap traces to strategy and capability gaps,
> funding/sequence realistic, every disposition has an ADR, regulatory claims verified.

## Step 7 — Communicate
Executive one-pager (BLUF, investment, outcomes, risks), architecture views per stakeholder (ArchiMate/C4),
decision log. Deliverables go in this ask's `.docs/` folder (chat: TL;DR + links); promote to the repo
(`docs/ea/…`) after G4 if the user wants.

## Final step — Adversarial audit (mandatory)
Follow `instructions/adversarial-audit.md` as the senior reviewer of this work. Tier: **Deep**.
Apply: A (roadmap ↔ strategy/capability traceability, sequencing, funding realism), B (every disposition/ADR), E (regulatory and lifecycle facts verified on primary sources). Fix Blockers before presenting; end with the 🔍 audit summary
(`principles/adversarial-self-audit.md`).
