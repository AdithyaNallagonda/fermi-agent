# UI Visual Design & Design Systems
Last reviewed: 2026-10 | Load when: visual design, design systems, tokens, theming, UI specs, prototypes.

## Visual hierarchy fundamentals
Size → weight → color/contrast → position → whitespace. One focal point per view; group with proximity; align to a
grid; repeat patterns for consistency; contrast for emphasis. Squint test: the primary action should still stand out.

## Layout & spacing
4/8-pt spacing scale (4, 8, 12, 16, 24, 32, 48, 64…); 12-column grid (desktop) / 4-column (mobile); max line
length 60–80 characters for body text; responsive breakpoints driven by content; container queries for components;
bento grids for feature showcases (tile size = importance).

## Typography
Modular type scale (e.g., 1.200 minor third or 1.250 major third); 2 families max (often one variable font);
body 16 px minimum on web (≥ 17 pt iOS default body), line-height 1.4–1.6 Latin (1.5–1.8 Indic); variable fonts for
weight/width/optical-size axes in one file; `font-display: swap`, subset, preload only the critical face. System
font stacks are the fastest option. Popular open families: Inter, Geist, IBM Plex, Source Sans 3, Manrope, Noto (for
script coverage). Check licenses for anything else.

## Color
Build palettes in perceptual spaces (OKLCH) for consistent lightness steps; 50–950 tonal ramps; semantic tokens
(primary, surface, on-surface, success, warning, danger, info); verify every text/background pair (4.5:1 / 3:1);
dark mode is a separate, tuned theme (not inverted) — avoid pure #000 backgrounds and fully saturated colors on dark;
color-blind safe data palettes; cultural color meanings for target markets (e.g., saffron/green/white in India,
red = prosperity in China, white = mourning in parts of Asia).

## Design tokens & theming
Token tiers: **primitive** (`blue-600`) → **semantic** (`color.action.primary`) → **component**
(`button.primary.bg`). Store in W3C Design Tokens Community Group format (JSON), transform with Style Dictionary/
Tokens Studio to CSS variables, Tailwind config, iOS/Android. Theming = swapping semantic token values (light/dark,
brand, density, high-contrast).

## Components & states
Every interactive component specifies: default, hover, focus-visible, active/pressed, disabled, loading, error,
selected, read-only; sizes; RTL; keyboard behavior; ARIA pattern; motion. Build on accessible headless primitives
(Radix UI, React Aria, Angular CDK/Material, Headless UI) + styling (Tailwind, CSS modules) — e.g., shadcn/ui-style
copy-in components.

## Platform design systems (know the references)
Apple Human Interface Guidelines (Liquid Glass material since iOS 26/macOS Tahoe 26 — translucent, refractive
layers for controls/navigation), Google **Material 3** incl. **Material 3 Expressive** (announced May 2025 with
Android 16: springy motion physics, richer shapes, emphasized type, new components such as button groups, FAB
menu, split button, toolbars), Microsoft Fluent 2, IBM Carbon, Atlassian, Shopify Polaris, GOV.UK (gold standard
for accessible public services), India's UX4G (government design system) ⚠️ verify current status.

## Motion
Purposeful: orientation, feedback, continuity. Durations ~100–300 ms for UI (longer for large surfaces); ease-out
on enter, ease-in on exit; spring physics for expressive systems; animate `transform`/`opacity` only (GPU,
no layout thrash); View Transitions API for page/state transitions; honor `prefers-reduced-motion`.

## Iconography & imagery
Single icon family with consistent stroke/corner/grid (Lucide, Phosphor, Material Symbols — variable icons);
icons + labels for ambiguous actions; SVG sprites; illustration style matched to brand; images: AVIF/WebP,
responsive `srcset`, explicit dimensions, lazy-load below the fold.

## Design tooling
Figma (Dev Mode, variables ↔ tokens, Code Connect), Penpot (open source), Storybook for component docs/tests,
Chromatic/Playwright visual regression, Lighthouse/axe for audits. AI-assisted UI generation (e.g., v0, Figma
AI features ⚠️ fast-moving) is fine for exploration — always re-audit generated UI for accessibility, consistency,
and licensing.

## Design QA checklist
Tokens only (no magic values) · all states designed · responsive at 320/768/1024/1440 · dark mode · a11y
annotations · contrast verified · copy final · performance budget respected · analytics events defined.
