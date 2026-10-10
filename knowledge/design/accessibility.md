# Accessibility (a11y) for Designers & Engineers
Last reviewed: 2026-10 — verified: WCAG 2.2 = ISO/IEC 40500:2025 (W3C news, 21 Oct 2025); WCAG 3.0 is a W3C
**Working Draft** (10 Sep 2026) that "does not deprecate WCAG 2"; EAA applies since 28 Jun 2025; India IS 17802
under RPwD (Amendment) Rules 2023 (secondary sources ⚠️ verify on BIS/DEPwD for compliance work).

## Standards & law (what to design to)
| Context | Target |
|---|---|
| Default (global) | **WCAG 2.2 Level AA** |
| EU products/services (EAA) | EN 301 549 (≈ WCAG 2.1 AA today) — design to WCAG 2.2 AA to be safe |
| US | ADA (courts use WCAG 2.1/2.2 AA), Section 508 (federal) |
| India | RPwD Act 2016 + **IS 17802** (ICT accessibility, aligned to WCAG 2.1) + GIGW 3.0 for government sites |
| WCAG 3.0 | Track only — not required; new conformance model and contrast method (APCA discussions) still in draft |

## WCAG 2.2 — what's new vs 2.1 (design impact)
- **2.4.11 Focus Not Obscured (Minimum) — AA**: sticky headers/cookie bars mustn't hide the focused element.
- 2.4.12 (AAA) / **2.4.13 Focus Appearance (AAA)** — strong focus indicators (adopt anyway).
- **2.5.7 Dragging Movements — AA**: provide a non-drag alternative (buttons) for drag-and-drop/sliders.
- **2.5.8 Target Size (Minimum) — AA**: ≥ 24×24 CSS px (or adequate spacing). Platform guidance is larger (Apple
  44 pt, Material 48 dp) — use those for touch.
- **3.2.6 Consistent Help — A**: help mechanisms in a consistent place.
- **3.3.7 Redundant Entry — A**: don't make users re-enter info already provided in the same process.
- **3.3.8 Accessible Authentication (Minimum) — AA**: no cognitive-function tests (no transcribing, puzzles);
  allow paste & password managers, passkeys, magic links.
- 4.1.1 Parsing removed.

## Designer checklist (AA)
Contrast: text 4.5:1 (large text ≥ 24 px or 18.66 px bold: 3:1); UI components & graphics 3:1 · Don't use color
alone · Visible, unobscured focus; logical focus order; skip link · Every input has a visible label (placeholder
≠ label); errors identified in text with suggestions · Headings/landmarks structure · Alt text strategy
(informative vs decorative) · Captions/transcripts for media · Reflow to 320 CSS px without horizontal scroll;
text resize 200%; text spacing overrides · `prefers-reduced-motion`: no essential info in motion; no flashing
> 3/s · Touch targets per platform; non-drag alternatives · Timeouts adjustable · Consistent navigation & help ·
Language of page/parts set (important for Indic + English mixed content) · Accessible auth.

## Engineering checklist
Semantic HTML first; ARIA only when needed (APG patterns for tabs, menus, dialogs, comboboxes); focus management
in SPAs (route change → move focus to `h1`/main); modal focus trap + return focus; live regions for async status;
`lang` attributes; form `autocomplete` tokens; charts with data tables/summaries; test with axe-core in CI +
manual NVDA/JAWS (Windows), VoiceOver (macOS/iOS), TalkBack (Android); keyboard-only pass.

## Cognitive & inclusive design
Plain language (aim ~grade 8 reading level), chunked steps, clear progress, forgiving inputs (accept multiple
formats for phone/date), undo over confirm dialogs, consistent patterns, low-literacy and multilingual users
(icons + labels, voice input), older adults (larger defaults), situational disabilities (glare, one hand, noise).

## Indic & multilingual specifics
Scripts need taller line-heights (≈ 1.5–1.8) and fonts with proper conjunct shaping (Noto Sans Devanagari/Tamil
etc., Mukta, Hind); avoid letter-spacing on Indic text; test text expansion (Hindi/Tamil often longer than
English); number/date formats (lakh/crore grouping via `Intl.NumberFormat('en-IN')`).

## Interview angles
"Make this checkout accessible" → labels, errors, focus, target size, accessible auth (OTP paste/autofill),
contrast, screen-reader announcements, testing plan; cite WCAG SC numbers.
