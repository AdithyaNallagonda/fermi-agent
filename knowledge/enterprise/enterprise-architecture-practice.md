# Enterprise Architecture Practice
Last reviewed: 2026-10 | Load when: EA role, roadmaps, portfolio rationalization, architecture governance,
TOGAF, capability maps, EA interviews.

## Mental model
Solution architects optimize **one system**; enterprise architects optimize **the portfolio over time** —
aligning business strategy, capabilities, applications, data and technology, and steering hundreds of
decisions through principles, standards, roadmaps and governance. EA succeeds when it **accelerates delivery**
(paved roads, reusable decisions) — not when it produces documents.

## TOGAF Standard, 10th Edition (The Open Group)
- **Structure**: *Fundamental Content* (6 linked documents: Introduction & Core Concepts · Architecture Development
  Method · ADM Techniques · Applying the ADM · Architecture Content · Enterprise Architecture Capability &
  Governance) + *TOGAF Series Guides* (now part of the standard: agile, security, digital, business
  architecture, government, etc.). Modular: adopt what you need.
- **ADM** (iterative; Requirements Management at the center):
  | Phase | Output that matters in practice |
  |---|---|
  | Preliminary | EA capability, principles, governance framework, tailored method |
  | A. Architecture Vision | Stakeholder map, scope, value proposition, Statement of Architecture Work |
  | B. Business Architecture | Capability map, value streams, org/process gaps |
  | C. Information Systems (Data + Application) | Data entities/flows, application portfolio & interactions |
  | D. Technology Architecture | Platforms, standards, infrastructure services |
  | E. Opportunities & Solutions | Work packages, build/buy/reuse, transition architectures |
  | F. Migration Planning | Sequenced, costed roadmap; business value per transition |
  | G. Implementation Governance | Architecture contracts, compliance reviews |
  | H. Architecture Change Management | Change triggers, re-entry into the cycle |
- Key concepts: Architecture Repository, Enterprise Continuum (generic → specific), building blocks (ABB/SBB),
  gap analysis, stakeholder concerns & viewpoints, architecture principles (name, statement, rationale,
  implications).
- Certs: TOGAF Enterprise Architecture Foundation (L1) → Practitioner (L2); TOGAF Business Architecture
  Foundation. Valuable for EA roles in Indian GCCs and services firms.

## Other frameworks & notations
ArchiMate 3.2 (EA modeling language aligned with TOGAF: business/application/technology layers, motivation,
strategy, implementation & migration), Zachman (ontology/classification), BIZBOK (business architecture),
C4 model (software architecture diagrams: context, container, component, code — use with ArchiMate for
enterprise views), Gartner pace-layering (systems of record / differentiation / innovation), Wardley maps
(evolution & build-vs-buy).

## Core EA artifacts (what good looks like)
1. **Business capability map** (L1–L3, stable, *what* not *how*) heat-mapped by strategic importance, maturity,
   cost, risk → drives investment.
2. **Value streams** mapped to capabilities → where to digitize/AI-enable.
3. **Application portfolio** (CMDB/LeanIX/Ardoq/ServiceNow APM): owner, capabilities served, users, cost, tech
   lifecycle, data classification, integration count, business fit × technical fit.
4. **Technology standards / Tech Radar** (adopt · trial · assess · hold) with lifecycle dates (EOL tracking:
   e.g., .NET 8/9 EOS 10 Nov 2026, Airflow 2 EOL Apr 2026, ingress-nginx retired, App Runner maintenance).
5. **Target state + transition architectures** and a **roadmap** tied to funding cycles.
6. **Reference architectures & patterns** (paved roads) with IaC modules — the EA→delivery bridge.
7. **Decision records** (ADRs/RFCs) searchable across the enterprise.

## Application portfolio rationalization
- **Gartner TIME**: Tolerate (good tech, low business value) · Invest (high/high) · Migrate (high value, poor
  tech) · Eliminate (low/low). Map to 7Rs for cloud.
- Steps: inventory → score business & technical fit + cost + risk → identify redundancy by capability (e.g., 4 CRMs)
  → disposition → roadmap → realize savings (license, infra, support) → track.
- Typical first-wave wins: duplicate capability consolidation, end-of-life platforms, shadow IT SaaS.

## Architecture governance that doesn't slow teams
- **Federated model**: central EA sets principles/guardrails/paved roads; domain architects embedded in value
  streams decide within guardrails.
- **Architecture Review Board (ARB)**: review only *significant* decisions (new platforms, cross-domain
  integration, data classification ≥ Confidential, exceptions). SLA ≤ 1 week. Async-first via RFC docs.
- **Guardrails as code**: SCPs/Azure Policy/Org Policy, IaC module registries, CI policy checks (OPA/Checkov),
  architecture fitness functions (ArchUnit-style tests, dependency rules, latency/cost budgets).
- **Exception process** with expiry and compensating controls.
- Agile/SAFe alignment: enterprise architect owns strategic themes & architectural runway; system architects per
  ART; enablers in PI planning.

## EA metrics (prove value)
Time-to-approve architecture decisions; % workloads on paved roads; application count & redundancy trend;
tech-debt/EOL exposure; cost per capability; reuse rate of platforms/APIs; security posture of portfolio;
delivery metrics (DORA) of teams using reference architectures; business outcomes of roadmap initiatives.

## EA for AI (2026 priority)
AI capability map (where AI changes value streams), AI platform reference architecture (gateway, RAG, agent
runtime, evals, guardrails), AI use-case portfolio with risk tiers (EU AI Act / NIST AI RMF / ISO 42001), agent
registry & identity, model lifecycle standards, data readiness assessment, FinOps for tokens.

## Interview angles (EA / principal roles)
- "How would you rationalize 600 applications after a merger?" → capability-based TIME + 7Rs + quick wins +
  governance + benefits tracking.
- "How do you keep EA relevant in an agile org?" → paved roads, federated decisions, fitness functions, ARB SLA.
- "Build a 3-year target architecture" → strategy → capabilities → gaps → transition architectures → funded
  roadmap → KPIs.
