# API Design
Last reviewed: 2026-10 | Load when: designing APIs, gateways, rate limits, real-time

## Style selection
| Style | Strengths | Weaknesses | Use |
|---|---|---|---|
| REST/JSON | Ubiquitous, cacheable, simple | Over/under-fetching, chatty | Public & CRUD APIs |
| gRPC (HTTP/2, Protobuf) | Fast, typed, streaming | Browser support needs gRPC-Web/Connect; less human-readable | Service-to-service |
| GraphQL | Client-shaped queries, one endpoint, schema | Caching harder, N+1 (use DataLoader), query cost control | Aggregation for many clients / BFF |
| WebSocket | Full-duplex, low latency | Stateful connections, scaling LB/sticky | Chat, collaboration, games |
| SSE | Simple server push over HTTP | One-way | Notifications, LLM token streaming |
| Webhooks | Push to partners | Delivery guarantees, security (HMAC signatures) | Integrations |
| Async (queues/events) | Decoupling, resilience | Eventual consistency | Long-running work (return 202 + status URL) |

## REST conventions
Resource nouns, plural; proper verbs and status codes (201 Created + Location, 202 Accepted, 204, 400,
401 vs 403, 404, 409 conflict, 412 precondition, 422, 429 + Retry-After, 503). Problem Details
(RFC 9457) for errors. ETag/If-Match for optimistic concurrency. HATEOAS rarely needed.

## Pagination
Offset/limit (simple; slow + inconsistent at depth) vs **cursor/keyset** (`WHERE (created_at,id) <
(:c, :id) ORDER BY … LIMIT n`; stable, fast). Return opaque `next_cursor`.

## Versioning
URI (`/v1/`), header, or media type. Prefer additive, backward-compatible changes; deprecate with
`Sunset`/`Deprecation` headers and timelines. Contract tests (Pact) between services.

## Idempotency
`Idempotency-Key` header on POST (payments, orders): store key → response for 24 h; same key + same
body → replay response; same key + different body → 422.

## Rate limiting
| Algorithm | Notes |
|---|---|
| Token bucket | Allows bursts up to bucket size; most common (API Gateway) |
| Leaky bucket | Smooth output rate |
| Fixed window counter | Simple; boundary bursts (2× at edges) |
| Sliding window log | Accurate; memory heavy |
| Sliding window counter | Approximation, cheap — good default for distributed |
Distributed implementation: Redis + Lua (atomic INCR/EXPIRE or token bucket script); per user/API key/
IP/tenant tiers; return `RateLimit-*` headers and 429. Local + global hybrid for very high RPS.

## API gateway responsibilities
AuthN/Z (JWT validation, OAuth scopes), throttling/quotas/usage plans, request validation, transform,
caching, routing/canary, WAF integration, observability. Options: Amazon API Gateway (REST/HTTP/
WebSocket), Azure API Management, Apigee/API Gateway (GCP), Kong, Envoy-based gateways.

## BFF (Backend for Frontend)
One backend per client type (web, mobile) to aggregate/shape data and keep tokens server-side.

## Security (OWASP API Top 10 2023)
BOLA is #1: always check object-level authorization (`resource.owner == caller` or policy engine).
Don't expose internal IDs needlessly; validate input schemas; limit payload sizes; never trust client-
side filtering. See `security/owasp.md`.
