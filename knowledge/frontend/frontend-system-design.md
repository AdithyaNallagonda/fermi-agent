# Frontend System Design
Last reviewed: 2026-10 | Load when: FE architecture, FE interviews, micro-frontends, rendering choices

## Rendering strategies
| Strategy | How | Best for | Trade-off |
|---|---|---|---|
| CSR (SPA) | JS renders in browser | Dashboards, authenticated apps | Slow first paint, SEO weaker |
| SSR | Server renders HTML per request, hydrates | SEO + dynamic content | Server cost, TTFB, hydration cost |
| SSG | Build-time HTML | Docs, marketing | Rebuilds for changes |
| ISR / revalidation | SSG + periodic/on-demand regen | Catalogs, blogs | Staleness window |
| Streaming SSR + Suspense | Send HTML in chunks | Fast TTFB on data-heavy pages | Complexity |
| React Server Components | Components run on server, zero client JS for them | Data-heavy apps (Next.js App Router) | New mental model, framework coupling |
| Islands / partial hydration | Hydrate only interactive parts | Content sites (Astro) | Less suited to app-like UIs |
| Resumability | No hydration replay (Qwik) | Very fast TTI | Ecosystem size |
| Edge rendering | SSR at CDN edge | Personalization with low latency | Runtime limits |

## State management
- **Server state** (remote data): TanStack Query / RTK Query / Apollo / Angular resource/httpResource —
  caching, dedup, background refetch, optimistic updates.
- **Client/UI state**: local component state, Context/signals, Zustand/Jotai/Redux Toolkit (React),
  NgRx Signal Store/services with signals (Angular).
- **URL state**: filters/pagination in query params (shareable).
- **Form state**: React Hook Form/Zod; Angular reactive forms/signal forms.
Rule: don't put server cache in a global store manually.

## Micro-frontends
Use only with many independent teams needing independent deploys. Options: Module Federation (Webpack/
Rspack), Native Federation (Angular/esbuild), single-spa, Web Components, server-side composition (edge
includes), iframes (strong isolation). Costs: duplicated deps, version skew, design-system consistency,
cross-app state/routing, performance. Monorepo (Nx/Turborepo) + shared design system often suffices.

## Real-time
Polling (simple), long polling, SSE (server→client), WebSockets (bi-directional), WebTransport;
reconnection with backoff, presence, offline queue, conflict resolution (CRDTs: Yjs/Automerge for
collaboration).

## Offline & PWA
Service workers (Workbox), cache strategies (cache-first for assets, network-first/stale-while-revalidate
for API), IndexedDB, background sync, manifest.

## Design systems
Tokens (color/spacing/typography) → primitives → components → patterns; Storybook; accessibility built
in; theming (CSS variables, dark mode); versioning and codemods.

## Testing pyramid
Unit (Vitest/Jest) → component (Testing Library, Angular TestBed/harnesses) → integration with MSW API
mocks → E2E (Playwright) → visual regression (Chromatic/Playwright snapshots) → a11y (axe).

## FE interview framework (RADIO)
Requirements → Architecture (components, rendering) → Data model (stores, normalization) → Interface
(API contracts, pagination) → Optimizations (performance, a11y, i18n, security). Classic prompts: news
feed, autocomplete, image carousel, chat UI, Google Sheets, video player, e-commerce PDP, Kanban board.

## Interview angles
Infinite scroll (IntersectionObserver + virtualization + cursor pagination); autocomplete (debounce,
cancel stale requests with AbortController, cache, keyboard a11y, highlight); choosing SSR vs CSR.
