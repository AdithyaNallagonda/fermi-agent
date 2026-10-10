# UX Research & Interaction Design
Last reviewed: 2026-10 | Load when: product discovery, flows, usability, UX reviews, UX interviews.

## Research toolkit (pick by question & budget)
| Question | Method | Effort |
|---|---|---|
| What problems/needs exist? | User interviews (5–8 per segment), contextual inquiry, diary studies | Medium |
| How do users behave now? | Analytics funnels, session replays, heatmaps, support-ticket mining | Low |
| Can they use it? | Moderated/unmoderated usability tests (5 users ≈ most major issues per round) | Low–Medium |
| Which works better? | A/B tests (needs traffic & power calculation), first-click tests | Medium |
| How should content be organized? | Card sorting, tree testing | Low |
| How satisfied are they? | SUS (68 ≈ average), CSAT, NPS (directional), UMUX-Lite | Low |
| Expert review | Nielsen's 10 heuristics, cognitive walkthrough | Low |
Synthesis: affinity mapping → insights → JTBD ("When <situation>, I want <motivation>, so I can <outcome>") →
opportunity solution tree (Teresa Torres) → prioritized bets.

## Nielsen's 10 usability heuristics
Visibility of system status · Match with the real world · User control & freedom (undo) · Consistency & standards ·
Error prevention · Recognition over recall · Flexibility & efficiency (shortcuts) · Aesthetic & minimalist design ·
Help users recognize, diagnose, recover from errors · Help & documentation.

## Laws of UX worth applying
Hick's law (fewer choices → faster decisions) · Fitts's law (bigger/closer targets) · Jakob's law (users expect
your product to work like others) · Miller's law (chunking) · Tesler's law (complexity has to live somewhere —
absorb it in the system) · Doherty threshold (respond < 400 ms to keep flow) · Peak-end rule · Von Restorff
(make the primary action distinct) · Serial position · Goal-gradient (show progress).

## Interaction patterns
- Forms: single column, labels above, smart defaults, inline validation on blur, input masks that don't fight
  paste, autofill tokens, clear required/optional, error summary + field errors.
- Navigation: ≤ 5 bottom-nav items on mobile; breadcrumbs for deep hierarchies; command palette (⌘K) for power users.
- States: design empty, loading (skeletons for > 300 ms; spinners for short waits), partial, error, offline, success.
- Feedback: optimistic UI with rollback; toasts for non-critical, inline for critical; undo > confirm.
- Search: autocomplete, typo tolerance, recent searches, filters as chips, zero-result recovery.
- Onboarding: progressive, value-first ("aha" in < 60 s), skippable tours, contextual hints.
- Notifications: user-controlled, batched, actionable; respect quiet hours.
- Data-dense UIs (dashboards): overview → zoom/filter → details on demand (Shneiderman), sensible defaults, sticky
  headers, density toggle; charts: pick the form by the question (trend → line, comparison → bar, part-to-whole
  → stacked bar over pie), label directly, color-blind-safe palettes, provide a data table alternative.

## AI-native UX (2025–2026)
Natural-language input alongside direct manipulation (not instead of); show sources/citations and confidence;
let users inspect, edit and override AI output; stream responses with stop/regenerate; make agent actions
previewable and reversible (human-in-the-loop for consequential steps); explain limitations; disclose AI use;
memory/personalization controls; graceful failure states. Avoid "chat for everything" when a button is faster.

## Ethical UX — dark patterns to refuse
Confirm-shaming, hidden costs (drip pricing), forced continuity, roach motel (hard cancellation), sneaking items into
basket, disguised ads, nagging, privacy zuckering, fake urgency/scarcity. Many are regulated (India CCPA Guidelines
for Prevention and Regulation of Dark Patterns, 2023 ⚠️ verify; EU DSA/UCPD; US FTC).

## Metrics
Task success rate, time on task, error rate, SUS, conversion/funnel completion, activation, retention (D1/D7/D30),
feature adoption, support contacts per user, accessibility defects.
