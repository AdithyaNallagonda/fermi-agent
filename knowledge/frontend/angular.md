# Angular
Last reviewed: 2026-10 — **Angular 22** is current (22.2.x as of Oct 2026); 6-month major cadence (next major ~Nov
2026). Since v21: zoneless is the default for new apps, signal forms matured, Vitest replaces Karma as default test
runner ⚠️ verify exact per-version details on angular.dev/events and endoflife.date/angular.

## Modern Angular (v17+) mental model
- **Standalone components** are the default (NgModules optional/legacy).
- **Signals**: `signal`, `computed`, `effect`, `linkedSignal`, `resource`/`httpResource` (async data
  ⚠️ API stability), signal inputs/outputs (`input()`, `output()`, `model()`), signal queries.
- **Built-in control flow**: `@if`, `@for` (requires `track`), `@switch`, `@let`.
- **Deferrable views**: `@defer (on viewport) {…} @placeholder {…}` for lazy-loading parts of templates.
- **Zoneless change detection** (`provideZonelessChangeDetection`) — stable in v20; default for new apps
  in v21 ⚠️ verify. With zone.js: use `OnPush` everywhere.
- **SSR & hydration**: `@angular/ssr`, full/incremental hydration (`hydrate on viewport`), event replay,
  route-level render modes (server/client/prerender).
- Build: esbuild + Vite dev server (application builder).
- Forms: reactive forms (typed); signal-based forms (experimental in v21 ⚠️).

## Architecture
- Feature-based folder structure; lazy-loaded routes (`loadComponent`, `loadChildren`).
- Smart (container) vs presentational components; services with signals for local/feature state.
- **NgRx**: Store (Redux pattern) for complex global state; **Signal Store** (`@ngrx/signals`) for
  lighter, signal-native state; ComponentStore legacy-ish. Don't use a global store by default.
- RxJS remains for streams/events (HTTP, websockets, complex async orchestration); interop via
  `toSignal`/`toObservable`. Avoid nested subscribes; use `takeUntilDestroyed`.
- Dependency injection: `inject()` function, providers at route/component level for scoping,
  injection tokens, `providedIn: 'root'` tree-shakable services.
- HTTP interceptors (functional) for auth, retries, error handling.
- Monorepos with Nx; micro-frontends via Native Federation.

## Performance
OnPush/zoneless; `track` in `@for`; `@defer`; lazy routes; avoid function calls in templates (use
`computed`); pure pipes; virtual scroll (CDK); image directive `NgOptimizedImage`; SSR + hydration for
LCP; bundle budgets in angular.json.

## Security
Built-in sanitization of bindings (avoid `bypassSecurityTrust*`); XSRF support in HttpClient; CSP with
nonces (`ngCspNonce`); Trusted Types support; route guards are UX — enforce authZ on the server.

## Testing
Jest/Vitest (Karma deprecated ⚠️), TestBed, component harnesses (CDK), Playwright/Cypress for e2e.

## Migration tips
`ng update` step by step; schematics: standalone migration, control flow migration, signal inputs
migration, inject migration.

## Interview angles
Change detection (zone.js vs zoneless vs OnPush); signals vs RxJS; DI hierarchy; lazy loading; NgRx
when and when not.
