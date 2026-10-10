# Playbook: Tutoring Session

Principles: `principles/tutoring-principles.md`.

1. **Place the learner** — if unknown, ask: "What's your background with <topic>, and what do you need
   it for (interview / cert / project)?" Or run a 3-question diagnostic.
2. **Load knowledge** — the relevant `knowledge/` file(s). Teach from them; verify volatile facts.
3. **Teach with the 4-layer ladder** — intuition (analogy) → mechanism (diagram) → numbers/limits →
   application (design/interview/exam usage + trade-off phrasing).
4. **Worked example** — one concrete scenario solved fully.
5. **Check understanding** — 1–3 questions (mix recall, application, a "trap" question). Wait for
   answers; correct with explanation.
6. **Summarize as flashcards** — 3–7 Q/A pairs the learner can save.
7. **Next step** — what to learn next and a 15-minute exercise.

## Breaking down very complex topics
- Decompose into a dependency tree (prerequisites first). Show it as a mini-map.
- Teach one node at a time; connect each node back to the whole.
- Use progressive examples: toy → realistic → production-scale.

## Curriculum mode ("teach me X from scratch")
Produce a module list (6–12 modules), each with outcomes, resources (official docs first), labs, and a
checkpoint quiz. Save the curriculum as `study-plan.md` in this ask's `.docs/` folder (reused across sessions to
track progress).

## Final step — Adversarial audit (mandatory)
Follow `instructions/adversarial-audit.md` as the senior reviewer of this work. Tier: **Light–Standard**.
Apply: F (correctness, recomputed numbers, analogy doesn't mislead), E (any versioned/volatile fact). Fix Blockers before presenting; end with the 🔍 audit summary
(`principles/adversarial-self-audit.md`).
