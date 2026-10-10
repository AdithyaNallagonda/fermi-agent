# Playbook: Interview Preparation

Knowledge: `knowledge/fundamentals/classic-design-problems.md`, other fundamentals,
`knowledge/career/india-solution-architect-market.md`.
Template: `templates/mock-interview-scorecard.md`.

## Step 1 — Intake
Target role (SDE2/SDE3/Staff/SA/Principal/Presales SA/Cloud Architect), company type (product,
GCC, IT services, startup, hyperscaler), interview date, rounds known, current strengths/gaps.

## Step 2 — Round map (typical; verify with recruiter)
| Round | What's assessed | Prep focus |
|---|---|---|
| HLD / System design | Requirements, estimates, trade-offs, depth | Framework in `system-design.md`, 20 classic problems |
| LLD / OOD | SOLID, patterns, class design, concurrency | Parking lot, rate limiter, LRU cache, splitwise, elevator |
| Cloud/solution architecture | Service selection, networking, security, cost, migration | Well-Architected, landing zones, DR, hybrid |
| Coding (for SDE tracks) | DSA | Patterns-based practice; not the focus of this agent |
| Presales / case study | Discovery, solutioning, whiteboarding to business | RFP response, TCO, migration pitch |
| Behavioral / leadership | Ownership, conflict, influence, failure | STAR(+L) stories bank, Amazon LPs if applicable |
| Hiring manager / bar raiser | Judgement, scope, culture | Scope-of-impact stories with metrics |

## Step 3 — Mock interview protocol (when user says "mock me")
1. Give the prompt like a real interviewer; stay silent on the framework — let them drive.
2. Answer clarifying questions realistically; withhold info they don't ask for.
3. Time-box: 5 min requirements, 5 estimates, 10 HLD, 15 deep dive, 5 wrap-up (45 min).
4. Push back like a bar raiser: "What if traffic 10×?", "Region goes down?", "Why not X?"
5. Score with `templates/mock-interview-scorecard.md`; give 3 strengths, 3 improvements, and a
   model answer outline.
6. Log weak areas → schedule targeted drills.

## Step 4 — Behavioral story bank
Build 8–10 STAR stories covering: conflict, failure, influence without authority, ambiguity,
tight deadline, mentoring, customer obsession, technical disagreement, cost saving, security incident.
Each with quantified result and lesson learned. Never fabricate — strengthen framing of real events.

## Step 5 — Plan
Generate a day-by-day plan to the interview date (`templates/study-plan.md`), mixing: 1 design
problem/day, 1 deep-dive topic/day, 2 behavioral stories/week, 2 mocks/week in the final 2 weeks.

## Answering style to coach
"Clarify → state assumptions → quantify → design simply → deepen where it matters → name trade-offs →
evolve." Phrase trade-offs as: *"I'm choosing X over Y because of Z requirement; the cost is W, which
I'd mitigate by V."*

## Final step — Adversarial audit (mandatory)
Follow `instructions/adversarial-audit.md` as the senior reviewer of this work. Tier: **Standard**.
Apply: A (prep plan fits days/hours available), F (model answers survive bar-raiser follow-ups), E (company/round-format claims flagged unless verified). Fix Blockers before presenting; end with the 🔍 audit summary
(`principles/adversarial-self-audit.md`).
