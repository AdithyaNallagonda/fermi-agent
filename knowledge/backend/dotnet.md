# .NET / ASP.NET Core
Last reviewed: 2026-10 — **.NET 10 (LTS, Nov 2025; supported to Nov 2028)** is the default target. **.NET 8 and
.NET 9 both reach end of support on 10 Nov 2026** (STS support was extended to 24 months) → plan upgrades now.
.NET 11 previews in progress (GA ~Nov 2026, STS with 24-month support).

## Platform essentials
Cross-platform runtime (CoreCLR), JIT with tiered compilation + PGO, **Native AOT** (fast startup, small
memory — great for Lambda/containers; limited reflection), GC modes (Server vs Workstation, DATAS dynamic
adaptation), Span<T>/Memory<T> for allocation-free code, `System.Text.Json` source generators.

## ASP.NET Core architecture
- Hosting: Kestrel; middleware pipeline (order matters: exception handling → HSTS → routing → CORS →
  authN → authZ → rate limiting → endpoints).
- **Minimal APIs** (lean, AOT-friendly) vs controllers (rich conventions). Both fine; minimal APIs with
  route groups + endpoint filters scale well.
- DI built in (transient/scoped/singleton; avoid captive dependencies).
- Configuration (appsettings + env vars + Key Vault/Secrets Manager providers), Options pattern with
  validation.
- Built-in rate limiting middleware, output caching, response compression, health checks, Problem
  Details, OpenAPI generation (Microsoft.AspNetCore.OpenApi in .NET 9+).
- gRPC, SignalR (real-time; Azure SignalR Service for scale-out), Blazor (Server/WebAssembly/Auto render
  modes).
- Background work: `BackgroundService`, `Channel<T>` for in-process producer/consumer, Hangfire/Quartz,
  or queues.

## Data access
EF Core (change tracking — use `AsNoTracking` for reads, compiled queries, split queries, bulk
`ExecuteUpdate/ExecuteDelete`, migrations, interceptors), Dapper for hot paths, connection pooling.

## Resilience & observability
`Microsoft.Extensions.Http.Resilience` (Polly v8: retry, circuit breaker, timeout, hedging) with
`IHttpClientFactory` (never `new HttpClient()` per request); OpenTelemetry .NET (traces/metrics/logs);
**.NET Aspire** for cloud-native app composition, service discovery, local orchestration and dashboards.

## Architecture styles
Clean/Onion/Hexagonal architecture, Vertical Slice architecture (feature folders + MediatR-style handlers
— note MediatR went commercial in 2025 ⚠️, consider alternatives or plain handlers), modular monolith with
module boundaries enforced by project references/architecture tests (NetArchTest/ArchUnitNET).

## Performance checklist
Async all the way (no `.Result`/`.Wait()`), avoid sync-over-async, pool objects (`ArrayPool`), use
`ValueTask` carefully, minimize allocations in hot paths, response caching, compression, benchmark with
BenchmarkDotNet, profile with dotnet-trace/dotnet-counters/PerfView.

## Security
ASP.NET Core Identity / external IdP (Entra ID, Auth0, Cognito) with OIDC; JWT bearer validation
(issuer, audience, lifetime, signing keys); policy-based authorization with requirements/handlers;
Data Protection API; antiforgery; secrets via user-secrets locally and managed identity in cloud;
SAST (Roslyn analyzers, SonarQube, CodeQL), SCA (Mend, `dotnet list package --vulnerable`).

## Hosting
Azure App Service / Container Apps / AKS / Functions (isolated worker model), AWS Lambda (Annotations,
Native AOT), ECS/EKS, Linux containers with chiseled Ubuntu images.

## Interview angles
Middleware vs filters; DI lifetimes bugs; async deadlocks; EF Core N+1 and tracking; scaling SignalR;
.NET on AWS cost/performance (Graviton + Native AOT).
