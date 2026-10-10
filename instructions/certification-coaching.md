# Playbook: Certification Coaching

Knowledge: `knowledge/certifications/<provider>.md` + the technology files mapped to exam domains.
Template: `templates/study-plan.md`.

## Step 1 — Verify the exam (mandatory)
Exam codes, domains/weights, question counts, duration, price and passing score change. Verify with
the official exam guide (AWS: aws.amazon.com/certification; Microsoft: learn.microsoft.com credentials — use
`microsoft-learn` MCP; Google: cloud.google.com/learn/certification; PMI: pmi.org; Scaled Agile:
scaledagile.com). Record the date you verified. If you can't verify it → **Gate G3**: ask or flag; never build
a plan on an unverified exam code or outline.

## Step 2 — Baseline
Ask experience with the platform + a 10-question diagnostic across domains. Note available hours/week
and exam date (or recommend one: Associate 4–8 weeks; Professional/Expert 8–12 weeks; PMP 8–12 weeks).

## Step 3 — Curriculum design
- Map each official domain → knowledge files in this KB → hands-on labs → practice questions.
- Weight study time by (domain weight × learner weakness).
- Structure per week: Learn (40%) → Lab (30%) → Practice questions (20%) → Review/flashcards (10%).
- Spaced repetition schedule for weak topics.

## Step 4 — Hands-on labs
Prescribe concrete free-tier/sandbox labs (with cost guardrails: budgets, alerts, teardown steps).

## Step 5 — Practice & exam technique
- Teach elimination: identify the requirement keywords ("most cost-effective", "least operational
  overhead", "highly available", "minimum changes") — they decide between plausible answers.
- Use only legitimate practice resources (official practice question sets, Skill Builder, Microsoft
  Learn practice assessments, reputable authors). No dumps.
- Readiness bar: ≥ 80% consistently on fresh practice sets, all domains ≥ 70%.

## Step 6 — Track
Weekly check-in: hours done, scores per domain, adjust plan. Final week: 2 full timed mocks, review
only mistakes, sleep.

## Certification pathways for SA aspirants (suggest when asked)
- AWS: CLF (optional) → SAA-C03 → SAP (C02 until 16 Nov 2026, then SAP-C03); add SCS-C03 / AIP-C01 / DEA / MLA-C02 per specialization (ANS-C01 retires 31 Dec 2026).
- Azure: AZ-900 (optional) → AZ-104 → AZ-305; add AZ-700 / SC-500 (replaced AZ-500) / AI-103 (replaced AI-102) / SC-100 per specialization.
- GCP: ACE → Professional Cloud Architect.
- Delivery: PSM I / SAFe Agilist / PMP. Security: CCSP/CSSLP for security-architect tracks.

## Final step — Adversarial audit (mandatory)
Follow `instructions/adversarial-audit.md` as the senior reviewer of this work. Tier: **Deep**.
Apply: E (exam code, domains, weights, dates, price verified on the official page THIS session), A (plan hours ≤ available hours, domain weighting matches the guide, readiness criteria present), F (explanations match current exam guide). Fix Blockers before presenting; end with the 🔍 audit summary
(`principles/adversarial-self-audit.md`).
