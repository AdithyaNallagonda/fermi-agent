# Playbook: UX / UI Design (apps, web pages, dashboards, flows)

Knowledge: `knowledge/design/ux-research-and-interaction.md`, `knowledge/design/ui-visual-and-design-systems.md`,
`knowledge/design/accessibility.md`, `knowledge/design/design-trends.md` (verify volatile trends),
`knowledge/frontend/*` for implementation.

## Step 1 — Frame (Gate G1)
Users & context (personas, devices, network, languages, accessibility needs), jobs-to-be-done, business goal &
success metrics (task success, time-on-task, conversion, retention, CSAT/SUS), constraints (brand, platform
guidelines — Apple HIG / Material 3, design system, tech stack, deadline). Confirm before designing.

## Step 2 — Understand
Lightweight research appropriate to budget: 5–8 user interviews, analytics/heatmaps, competitor teardown,
support tickets, heuristic evaluation (Nielsen's 10). Synthesize → problem statements + top pain points.

## Step 3 — Structure
Information architecture (card sort/tree test when navigation matters), user flows for primary + error paths,
content model, empty/loading/error/offline states, permissions & edge cases.

## Step 4 — Wireframe → visual design
- Low-fidelity layout first (mobile-first, content-first); one primary action per view.
- Visual system: tokens (color with contrast-checked pairs, type scale, spacing 4/8-pt, radius, elevation, motion),
  components, states (hover, focus-visible, active, disabled, loading, error), dark mode, density modes.
- Offer **2–4 directions** (e.g., calm/minimal, expressive, data-dense) with rationale → **Gate G2**.
- Deliverables can be: annotated ASCII/Mermaid wireframes, HTML/CSS (Tailwind) or React/Angular prototypes, SVG
  assets, design-token JSON (W3C Design Tokens format), component specs.

## Step 5 — Accessibility & performance pass (non-negotiable)
WCAG 2.2 AA checklist from `knowledge/design/accessibility.md` (focus order/visibility, target size ≥ 24×24 CSS px,
contrast 4.5:1/3:1, labels, error identification, reduced motion, no drag-only actions, accessible auth); India
IS 17802 / GIGW and EU EAA where relevant. Performance budget: LCP ≤ 2.5 s, INP ≤ 200 ms, CLS ≤ 0.1 at p75; image
formats/sizes, font strategy (variable fonts, subsetting, `font-display`), animation cost (transform/opacity only).

## Step 6 — Validate
Usability test plan (5 users per round, task scenarios, success criteria), automated checks (axe, Lighthouse),
manual screen-reader pass (NVDA/VoiceOver/TalkBack), A/B or staged rollout metrics.

## Step 7 — Handoff
Specs with tokens, redlines, interaction/motion specs (duration/easing), copy deck, a11y annotations (roles,
names, focus order), analytics events, acceptance criteria per story.

> **Audit checkpoint (B + F + D) — before presenting designs:** every requirement/persona need addressed, contrast
> pairs recomputed, a11y checklist actually checked, performance cost stated, trends justified, no dark patterns,
> prototype code runs.

## Final step — Adversarial audit (mandatory)
Follow `instructions/adversarial-audit.md` as the senior reviewer. Tier: **Standard** (Deep for regulated/
public-sector or large launches). Apply: A (flows cover all requirements incl. error/empty states), B (direction
choice), D (prototype/code runs; a11y checks evidenced), E (trend/guideline claims verified). Fix Blockers; end
with the 🔍 audit summary.
