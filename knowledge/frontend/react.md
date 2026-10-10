# React (and Next.js)
Last reviewed: 2026-10 — React **19.2.x** stable (19.3 supported by Next.js 16.4); React Compiler 1.0 (Oct 2025);
**Next.js 16.4** (Oct 2026). React 19.2 added `<Activity>`, `useEffectEvent`, partial pre-rendering APIs ⚠️ verify.

## Core model
UI = f(state). Components re-render when state/props/context change; reconciliation diffs virtual DOM;
**keys** identify list items (never index for dynamic lists). Concurrent rendering: transitions
(`useTransition`, `useDeferredValue`) keep UI responsive; Suspense for async boundaries.

## React 19 essentials
- **Actions**: async functions in transitions; `useActionState`, `useFormStatus`, `useOptimistic`;
  `<form action={fn}>`.
- `use()` to read promises/context in render.
- **Server Components** & Server Functions (`"use server"`) via frameworks (Next.js App Router, React
  Router framework mode).
- ref as a prop (no forwardRef), document metadata tags, resource preloading APIs.
- **React Compiler**: automatic memoization → far less manual `useMemo`/`useCallback`/`memo`.

## Hooks rules & pitfalls
Call at top level; effects are for synchronizing with external systems — not for derived state or event
logic ("You might not need an effect"); cleanup subscriptions; stale closures; dependency arrays honest
(lint rule). Avoid storing derived data in state.

## State & data
TanStack Query for server state; Zustand/Jotai/Redux Toolkit for global client state; Context for low-
frequency values (theme, auth) — high-frequency context causes broad re-renders.

## Performance
Measure with React DevTools Profiler; code-split (`lazy` + Suspense, route-based); virtualize long lists
(TanStack Virtual); avoid unnecessary re-renders (state colocation, compiler); image optimization
(next/image); stable keys; web workers for heavy compute; bundle analysis.

## Next.js App Router architecture
`app/` routes with layouts, server components by default, `"use client"` islands, data fetching in
server components with caching/revalidation (caching semantics changed across 14→15→16 ⚠️ verify),
route handlers, middleware (edge), server actions (validate & authorize every action — they are public
endpoints!), ISR, streaming with `loading.tsx`, Partial Prerendering ⚠️.

## Security
JSX escapes by default — avoid `dangerouslySetInnerHTML` (sanitize with DOMPurify if necessary); don't
leak secrets into client bundles (`NEXT_PUBLIC_` only for public); CSP with nonces; auth tokens in
httpOnly cookies via BFF; validate server action inputs (Zod) and check authZ server-side.

## Project structure (feature-based)
```
src/
  app/ (routes)        features/<feature>/{components,hooks,api,types}
  shared/{ui,lib,config}  test/
```

## Interview angles
Reconciliation & keys; useEffect vs useLayoutEffect; controlled vs uncontrolled; RSC vs SSR difference
(RSC = component-level server execution with serialized output; SSR = HTML generation for initial load);
preventing re-renders.
