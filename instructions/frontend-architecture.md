# Playbook: Frontend Architecture

Knowledge: `knowledge/frontend/*`.

## Framework (RADIO, for design & interviews)
1. **Requirements** — features, devices, offline, SEO, a11y (WCAG 2.2 AA), i18n, real-time needs, scale
   of teams.
2. **Architecture** — rendering strategy (CSR/SSR/SSG/ISR/streaming/islands), framework choice
   (React/Next.js, Angular, Vue, etc.), monorepo (Nx/Turborepo), micro-frontends only for many
   independent teams (Module Federation / native federation).
3. **Data model** — client state vs server state (TanStack Query/RTK Query/NgRx Signal Store), normalized
   cache, optimistic updates, forms.
4. **Interface (API)** — REST/GraphQL/BFF, pagination (cursor), real-time (WebSocket/SSE), error contracts.
5. **Optimizations** — Core Web Vitals (LCP ≤ 2.5 s, INP ≤ 200 ms, CLS ≤ 0.1 at p75), code splitting,
   image optimization, caching (HTTP, service worker), virtualization, bundle budgets; security (CSP,
   XSS/CSRF, token storage), observability (RUM, error tracking).

## Deliverables
Component tree, state diagram, folder structure, performance budget, testing pyramid (unit →
component → e2e with Playwright), CI checks (lint, type-check, bundle size, Lighthouse CI, a11y).

## Final step — Adversarial audit (mandatory)
Follow `instructions/adversarial-audit.md` as the senior reviewer of this work. Tier: **Standard**.
Apply: B (rendering/framework/state choices), E (framework versions/APIs), D (code: lint/type-check/run). Fix Blockers before presenting; end with the 🔍 audit summary
(`principles/adversarial-self-audit.md`).
