# Playbook: Brand Identity — Naming, Logo, Visual Identity, Voice

Knowledge: `knowledge/design/branding-logo-and-naming.md`, `knowledge/design/design-trends.md`,
`knowledge/design/ui-visual-and-design-systems.md`, `knowledge/design/accessibility.md`.
Principles: `principles/design-principles.md` (#9–#12 especially), `principles/ethics-and-boundaries.md`.

## Step 1 — Brand strategy brief (Gate G1)
Audience, category, positioning ("For <who> who <need>, <brand> is the <category> that <benefit>, unlike
<alternative>"), brand personality (3–5 traits on spectrums, e.g., playful ↔ serious), values, competitors'
visual/verbal territory, markets & languages (India: Hindi + regional scripts?), channels (app icon, web, print,
merch, motion), constraints (budget, existing equity, sub-brands). Confirm.

## Step 2 — Naming (when needed)
1. Name strategy: descriptive · suggestive · abstract/invented · compound · founder/heritage · acronym (avoid).
2. Generate **30–60 candidates** across strategies (word roots, metaphors, Sanskrit/Indic roots where fitting,
   portmanteaus, coined words); shortlist 8–12 with rationale.
3. Screen: length (≤ 3 syllables ideal), pronounceable across target languages, spelling-on-hearing, no negative
   meanings/slang in target languages, distinctiveness vs competitors, story potential, extendability.
4. **Availability checks are mandatory before calling any name "available" (Gate G3)**: domains (.com/.in/.ai via
   registrar/WHOIS), social handles, app-store names, trademark databases (WIPO Global Brand Database, IP India
   public search, USPTO trademark search, EUIPO) in relevant classes — report as *preliminary screening*,
   recommend clearance by a trademark attorney. If you can't check with tools, say so explicitly.
5. Present top 3–5 with meaning, pronunciation, screening results → **Gate G2**.

## Step 3 — Logo & identity concepts
- Explore **3 distinct directions** (e.g., wordmark, monogram/lettermark, abstract symbol, emblem, mascot,
  dynamic/responsive mark) tied to the strategy; sketch rationale for each.
- Build as **SVG** (clean geometry, minimal nodes, `viewBox`, `title`/`aria-label`, no embedded raster), designed
  **monochrome first**, then color.
- Responsive logo system: primary lockup, horizontal/stacked, symbol-only, favicon (16/32 px), app icon (iOS/
  Android adaptive), motion variant (optional), clear space & minimum sizes.
- Test: legibility at 16 px, one-color/inverted, dark/light backgrounds, contrast ≥ 3:1 for graphical objects,
  silhouette recognizability, distinctiveness vs competitors, cultural meaning of symbols/colors in target markets.
- If a browser/screenshot tool is available (e.g., Playwright MCP), render and inspect; otherwise describe how to
  preview and state that visual QA is pending.

## Step 4 — Visual identity system
Color palette (primary/secondary/neutrals/semantic with accessible text pairs and contrast ratios), typography
(licensed fonts — Google Fonts/open licenses or properly licensed; Indic script coverage, e.g., Noto/Mukta/
Hind families), iconography style, imagery/illustration direction, grid, motion principles, design tokens.

## Step 5 — Verbal identity
Voice & tone (attributes with do/don't examples), tagline options, messaging hierarchy, naming conventions for
products/features, microcopy patterns (errors, empty states, CTAs), inclusive-language rules.

## Step 6 — Brand guidelines deliverable
One-pager or brand book outline: strategy, logo usage (do/don't), color, type, voice, examples, file kit list
(SVG/PNG/PDF, favicon set, app icons, social avatars). Write concepts, SVGs and the guideline into this ask's `.docs/` folder (assets in `scratch/` until approved); promote final assets into the project after G4.

> **Audit checkpoint (B + E + F) — before presenting:** originality (no resemblance to existing marks you know
> of — and say that a formal search is still needed), name screening evidence real (no invented availability),
> contrast computed, SVG valid, cultural checks done for target markets.

## Final step — Adversarial audit (mandatory)
Tier: **Standard** (Deep before any public launch or trademark filing). Apply §B (direction choice), §D (SVG/code
validity), §E (availability/trademark/trend claims — verified or flagged), §F (rationale accuracy). Fix Blockers;
end with the 🔍 audit summary.
