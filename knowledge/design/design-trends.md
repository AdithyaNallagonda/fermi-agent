# Design Trends (2025–2026)
Last reviewed: 2026-10 ⚠️ Trends are the most volatile content in this KB — re-verify before presenting as
current. Platform facts verified via multiple sources 2026-10-10; trend lists come from industry blogs (secondary).

## Platform-level shifts (verified)
- **Apple Liquid Glass** — previewed June 2025, shipped across iOS 26, iPadOS 26, macOS Tahoe 26: translucent,
  refractive, reflective material for controls/navigation layered over content. Implication: on Apple platforms,
  native controls look glassy; for web, imitate sparingly (backdrop-filter costs performance; contrast over
  busy backgrounds is an accessibility risk — test with real content and "Reduce Transparency").
- **Material 3 Expressive** — announced May 2025 with Android 16/Wear OS 6: evolution of Material 3 (not "M4")
  with spring-based motion physics, expressive shapes, emphasized typography, background blur for depth, new
  components (button groups, FAB menu, loading indicator, split button, toolbars).

## UI/UX trends (secondary sources — use with judgment)
| Trend | Use when | Risk |
|---|---|---|
| Calm, content-first "expressive minimalism" | Most products | Bland if no brand personality |
| Bento-grid layouts | Landing pages, feature showcases, dashboards | Becoming ubiquitous → generic |
| Glass/translucency (post-Liquid Glass) | Overlays, nav bars on Apple-adjacent brands | Contrast, GPU cost |
| Variable & kinetic typography | Brand moments, hero sections | Motion sickness, performance; respect reduced motion |
| AI-native interfaces (NL input + direct manipulation, transparent/overridable AI) | AI products, copilots | Chat-for-everything anti-pattern |
| Dark mode done properly, high-contrast themes | All apps | Inverted-palette shortcuts |
| Micro-interactions & spring motion | Feedback & delight | Overuse, a11y |
| Personalization/adaptive UI | Content & commerce | Privacy (DPDP/GDPR), unpredictability |
| Spatial/3D accents (lightweight) | Brand storytelling | Bundle size, LCP |

## Branding & logo trends (secondary sources)
Logos as **adaptive systems** (marks defined by behavior across UI, motion, icons) · **kinetic/motion logos** ·
**human, tactile, authentic** identities reacting against generic sans-serif wordmarks · multi-dimensional, playful
identities · custom typography as identity · bold color with restraint · heritage/craft cues for trust brands.

## How to use trends (rule)
Foundations timeless (grid, type, contrast, accessibility, performance); trends as accents that fit the brand and
audience; run the "3-year test" — will it look dated? Prefer platform-native patterns (HIG/Material) inside apps,
brand expression at marketing surfaces.
