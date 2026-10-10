# Branding, Logo Design & Naming Systems
Last reviewed: 2026-10 | Load when: brand identity, logos, product/company naming, naming conventions.

## Brand foundations
Purpose → positioning → personality → promise → proof. Brand architecture: branded house (one master brand),
house of brands, endorsed, hybrid. Archetypes (Jungian 12: Creator, Sage, Hero, Explorer, Caregiver…) are a handy
shortcut for personality. Brand equity is built by consistency over time — change carefully.

## Logo types (choose by name, audience, budget)
| Type | Best when | Watch |
|---|---|---|
| Wordmark | Distinctive, short name; early-stage startups | Needs strong custom lettering to be ownable |
| Lettermark/monogram | Long names; app icons | Generic unless crafted |
| Pictorial/symbol | Strong metaphor, global use | Needs time/money to build recognition |
| Abstract mark | Platform/tech brands | Easy to look like everyone else |
| Combination mark | Most SMBs/new products | Define lockups & symbol-only use |
| Emblem | Heritage, institutions | Poor at small sizes |
| Mascot | Consumer, playful brands | Scaling & tone limits |
| Dynamic/responsive identity | Digital-first, multi-surface brands | Needs rules (system thinking) |

## Logo craft rules
Concept first (meaning, story) → sketches → vector refinement. Simple geometry, optical (not mathematical)
balance, consistent stroke/radius, negative space used deliberately, works **in one color**, recognizable as a
silhouette, legible at 16 px favicon and app-icon sizes, clear-space and minimum-size rules, avoid gradients/
effects as load-bearing elements (add as optional treatments), avoid thin hairlines and tight counters.
**SVG best practice**: `viewBox`, integer-snapped coordinates where possible, minimal paths, no transforms on
final paths, `role="img"` + `<title>`, optimize with SVGO, provide outlined text (no font dependency).

## Identity system deliverables
Primary/secondary lockups, symbol, favicon set (ICO/SVG/PNG 16–512), iOS/Android adaptive icons, social avatars,
color palette (with contrast-checked pairs), typography, iconography, imagery/illustration style, motion logo,
templates (deck, social, email signature), brand guidelines.

## Naming — strategy & process
Types: descriptive (clear, weak protection) · suggestive (balanced — often best) · abstract/coined (ownable,
needs marketing) · compound/portmanteau · evocative metaphor · founder/place · acronym (avoid for new brands).
Generation techniques: semantic fields & metaphors, root morphemes (Latin/Greek/Sanskrit), sound symbolism
(plosives = energetic; liquids/vowels = soft), truncation/blending, misspelling (use sparingly — hurts recall),
two-word combos.
Screening criteria: memorable, pronounceable in target languages, one obvious spelling, ≤ 3 syllables, no
negative/obscene meanings in target languages & slang (check Hindi and relevant regional languages for India),
distinct from competitors, extendable, emotionally fitting, available (see below).

## Availability & legal screening (never fabricate results)
Domains (registrar/WHOIS; consider .com, .in, .ai, .io, .co), social handles, app-store listings, company name
availability (India MCA name search ⚠️), trademark databases — **WIPO Global Brand Database**, **IP India public
search**, **USPTO trademark search**, **EUIPO eSearch** — in relevant Nice classes (9 software, 35 business, 42
SaaS/tech). Agent output = preliminary screening only; recommend a trademark attorney before adoption. If tools
can't check, say "not checked".

## Naming conventions (product & technical)
- **Product/feature names**: descriptive for features ("Smart Reply"), branded only for flagship capabilities;
  consistent grammar (nouns for features, verbs for actions); no internal codenames in UI.
- **UI copy**: sentence case for buttons/headings (modern default), verbs on buttons ("Save changes" not "OK").
- **APIs**: plural nouns for resources (`/orders/{id}`), kebab-case URLs, camelCase or snake_case JSON consistently,
  verbs only for actions that aren't CRUD (`/orders/{id}:cancel` or `/orders/{id}/cancel`).
- **Design tokens**: `category.property.variant.state` (e.g., `color.text.primary.hover`).
- **Components**: PascalCase (`DatePicker`), props camelCase, CSS BEM or utility conventions consistently.
- **Cloud resources**: `<org>-<env>-<region>-<app>-<resource>` (e.g., `acme-prod-aps1-payments-api`) + mandatory
  tags (owner, cost-center, environment, data-classification).
- **Code**: language-idiomatic (PEP 8, .NET conventions, Angular style guide), intention-revealing names, no
  abbreviations except well-known ones.

## Creative process for the agent
Divergent (many options, varied strategies) → convergent (criteria scoring matrix) → present 3 directions with
rationale and mockups (SVG / HTML) → feedback → refine. Originality: don't imitate existing marks; check for
resemblance to famous logos you know; disclose that a formal search is still needed.
