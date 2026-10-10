# Playbook: Project Delivery (Scrum / SAFe / PMP)

Knowledge: `knowledge/delivery/*`. Templates: `templates/epic-feature-story.md`.

## Choose the approach
| Context | Approach |
|---|---|
| 1 team, evolving scope | Scrum or Kanban |
| 3–12 teams on one value stream (50–125 people) | SAFe Essential (ART) |
| Fixed scope/contract, regulatory | Predictive (PMBOK) or hybrid (predictive governance + agile execution) |
| Ops/support heavy | Kanban with SLAs |

## Common deliverables (produce on request)
- **Project charter** — objectives, scope, success criteria, milestones, budget, stakeholders, risks.
- **Roadmap** — Mermaid Gantt; PI roadmap for SAFe.
- **Backlog** — epics (with lean business case), features (benefit hypothesis + acceptance criteria),
  stories (INVEST, Given/When/Then), enablers (architecture/infra/compliance).
- **Estimation** — story points with reference stories; for SAFe normalized points; for predictive:
  WBS + three-point (PERT = (O + 4M + P) / 6).
- **PI planning kit** — agenda (2 days), team breakout templates, program board, ROAM, confidence vote.
- **RAID log** — Risks, Assumptions, Issues, Dependencies with owners/dates.
- **Status report** — RAG status, milestones, burn-up, top risks, decisions needed.
- **Metrics** — velocity (team-internal only), cycle time, throughput, predictability (PI objectives
  achieved %), flow metrics, EVM for predictive (CPI = EV/AC, SPI = EV/PV).

## Ceremonies coaching
Give facilitation scripts with timeboxes for sprint planning, daily scrum, review, retro, backlog
refinement, PI planning, Inspect & Adapt.

## Final step — Adversarial audit (mandatory)
Follow `instructions/adversarial-audit.md` as the senior reviewer of this work. Tier: **Standard**.
Apply: A (schedule, dependencies, capacity math, critical path, RAID completeness), R-check EVM/PERT arithmetic. Fix Blockers before presenting; end with the 🔍 audit summary
(`principles/adversarial-self-audit.md`).
