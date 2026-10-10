# Scrum, Kanban & Agile Practices
Last reviewed: 2026-10 | Source: Scrum Guide 2020

## Agile Manifesto (4 values)
Individuals & interactions over processes & tools · Working software over comprehensive documentation ·
Customer collaboration over contract negotiation · Responding to change over following a plan.
(Plus 12 principles.)

## Scrum (2020 Guide)
- **Pillars**: transparency, inspection, adaptation. **Values**: commitment, focus, openness, respect,
  courage.
- **Accountabilities**: Product Owner (maximizes value, owns Product Backlog), Scrum Master (team
  effectiveness, servant-leader & coach), Developers (create the increment). One Scrum Team, ≤ ~10 people.
- **Events** (timeboxes for a 1-month sprint; shorter sprints proportionally shorter):
  Sprint (≤ 1 month) · Sprint Planning (≤ 8 h: Why/What/How) · Daily Scrum (15 min, for Developers) ·
  Sprint Review (≤ 4 h) · Sprint Retrospective (≤ 3 h).
- **Artifacts & commitments**: Product Backlog → Product Goal; Sprint Backlog → Sprint Goal;
  Increment → Definition of Done.
- Backlog refinement is an ongoing activity (not an event), typically ≤ 10% capacity.

## Kanban
Visualize work, limit WIP, manage flow, make policies explicit, feedback loops, improve collaboratively.
Metrics: cycle time, throughput, WIP, work item age, cumulative flow diagram. Monte Carlo forecasting from
throughput history beats story-point velocity for date forecasts.

## Estimation
Story points (relative, Fibonacci), planning poker, t-shirt sizing for epics, #NoEstimates (count items
with right-sized stories), reference stories. Velocity is a planning tool for the team, never a
performance metric.

## User stories
INVEST (Independent, Negotiable, Valuable, Estimable, Small, Testable); acceptance criteria in Given/When/
Then; split by workflow steps, business rules, data variations, CRUD operations, happy/unhappy paths,
spikes for unknowns.

## Retrospective formats
Start/Stop/Continue, 4Ls (Liked, Learned, Lacked, Longed for), Sailboat, Mad/Sad/Glad, Timeline, 5 Whys.
Output: 1–2 actionable improvements with owners, added to the sprint backlog.

## Scrum Master toolkit
Facilitation, impediment removal, coaching PO on backlog management, protecting focus, metrics (cycle
time, sprint goal success rate), team health checks (Spotify model), conflict navigation, scaling
(Nexus, LeSS, SAFe, Scrum@Scale).

## Common dysfunctions & fixes
| Dysfunction | Fix |
|---|---|
| Sprint goals absent; sprint = bag of tasks | Coach PO to set outcome-based goals |
| Carry-over every sprint | Smaller stories, WIP limits, capacity-based planning |
| Daily scrum = status report to manager | Refocus on goal progress & impediments; manager observes only |
| No real Done increment | Strengthen DoD (tests, CI/CD), swarm on finishing |
| Velocity weaponized | Remove from performance reviews; use flow metrics |
