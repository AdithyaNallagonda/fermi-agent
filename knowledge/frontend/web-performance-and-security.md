# Web Performance, Security & Accessibility
Last reviewed: 2026-10

## Core Web Vitals (good thresholds at p75)
| Metric | Good | Measures | Levers |
|---|---|---|---|
| LCP | ≤ 2.5 s | Loading of largest element | Fast TTFB (CDN/SSR/caching), preload hero image, `fetchpriority="high"`, modern formats (AVIF/WebP), responsive images, critical CSS |
| INP | ≤ 200 ms | Interaction responsiveness (replaced FID in 2024) | Break long tasks (> 50 ms), yield (`scheduler.yield`), less JS, web workers, avoid layout thrash |
| CLS | ≤ 0.1 | Visual stability | Width/height on media, reserve space for ads/embeds, `font-display` + size-adjust |
Also: TTFB, FCP, TBT (lab). Measure with field data (CrUX, RUM via web-vitals library) and lab (Lighthouse,
WebPageTest).

## Loading optimizations
Code splitting, tree shaking, modern JS targets, compression (Brotli), HTTP/2/3, CDN caching with
hashed assets, preconnect/dns-prefetch, lazy-load below-the-fold images (`loading="lazy"`), font
subsetting, third-party script governance (defer/async, partytown), Speculation Rules for prefetch/
prerender.

## Rendering optimizations
Avoid forced synchronous layouts; use `transform`/`opacity` for animations; `content-visibility: auto`;
virtualization; memoization; debounce/throttle input handlers.

## Performance budgets
JS ≤ ~170 KB compressed on critical path (mobile guidance), LCP budget per page type; enforce in CI
(Lighthouse CI, bundlesize).

## Frontend security
- **XSS**: framework escaping, sanitize HTML (DOMPurify), **CSP** (`script-src 'nonce-…' 'strict-dynamic'`),
  Trusted Types.
- **CSRF**: SameSite cookies (Lax/Strict), anti-CSRF tokens for cookie auth.
- **Token storage**: prefer httpOnly, Secure, SameSite cookies via BFF; avoid long-lived tokens in
  localStorage. OAuth 2.0 Authorization Code + PKCE for SPAs.
- **Clickjacking**: `frame-ancestors` CSP.
- Headers: HSTS, X-Content-Type-Options, Referrer-Policy, Permissions-Policy.
- Supply chain: lockfiles, SCA scanning, SRI for third-party CDN scripts.
- CORS is not authentication; configure allowlists narrowly.

## Accessibility (WCAG 2.2 AA) — full checklist in `design/accessibility.md`
Semantic HTML first; keyboard navigation and visible focus; labels for inputs; color contrast (4.5:1
text); ARIA only when needed (no ARIA is better than bad ARIA); alt text; focus management in SPAs on
route change; prefers-reduced-motion; test with axe + screen readers (NVDA, VoiceOver). Legal relevance:
ADA (US), EAA (EU, enforceable from June 2025), RPwD Act / GIGW (India).

## i18n
ICU message format, RTL support (logical CSS properties), locale-aware dates/numbers (Intl API), lazy
load translations.
