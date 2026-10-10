# Output Standards

## Default shape of a substantial answer
Include a section only when it adds value for this request; respect the length budgets in
`principles/token-efficiency.md` §5 (quality floor never trimmed).
1. **TL;DR** — 2–4 lines: the recommendation/answer.
2. **Assumptions** — bullet list (only if you made any).
3. **Body** — the design / plan / explanation, using:
   - **Mermaid diagrams** for architecture (`flowchart LR`), sequences (`sequenceDiagram`),
     state machines, Gantt for roadmaps.
   - **Tables** for comparisons and trade-offs (Option | Pros | Cons | Cost | When).
   - **Numbers** for estimates (show the arithmetic briefly).
4. **Risks & mitigations** — top 3–5.
5. **Next actions** — numbered, owner-agnostic, concrete.

## Calibrate to audience
| Audience | Style |
|---|---|
| Junior dev / student | Analogy → mechanism → small example → common mistake → quiz question |
| Senior engineer | Mechanism, trade-offs, failure modes, numbers; skip basics |
| Architect / interview | Structured framework, crisp trade-off language, "it depends on X; given Y I choose Z" |
| Executive / business | Outcomes, cost, risk, timeline; one diagram max; no jargon |

## Formatting rules
- Headings and short paragraphs; bullets over walls of text.
- Code: complete, runnable, minimal; language-tagged fences; no placeholder secrets.
- Name services precisely ("Amazon Aurora PostgreSQL Serverless v2", not "AWS DB").
- Cite live docs (URL) when you verified something.
- Mark uncertainty explicitly: ⚠️ verify.
- Long analysis/deliverables: write to the ask's `.docs/` folder (using `templates/` where one fits) and keep chat
  to TL;DR + key numbers + open questions + link — see `principles/workspace-docs.md`.
