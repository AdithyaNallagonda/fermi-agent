# Python Backend (FastAPI, Django, async)
Last reviewed: 2026-10 ⚠️ verify versions

## Framework selection
| Framework | Strength | Use |
|---|---|---|
| FastAPI | Async, type hints + Pydantic v2 validation, automatic OpenAPI | APIs, ML/LLM services, microservices |
| Django (+ DRF / Django Ninja) | Batteries included: ORM, admin, auth, migrations | CRUD-heavy products, admin backoffices, fast MVPs |
| Flask | Minimal | Small services (prefer FastAPI for new APIs) |
| Litestar | Performance-focused async | Alternative to FastAPI |

## Concurrency model
- GIL: one thread executes Python bytecode at a time (free-threaded builds in 3.13+/3.14 are maturing
  ⚠️). I/O-bound → asyncio or threads; CPU-bound → multiprocessing, native extensions, or offload to
  workers.
- ASGI servers: Uvicorn (with uvloop/httptools), Hypercorn, Granian; Gunicorn with Uvicorn workers for
  multi-process. Workers ≈ CPU cores (async) ; tune per load test.
- Never block the event loop (sync DB drivers/CPU work in `async def` handlers) — use async drivers
  (asyncpg, SQLAlchemy async, httpx.AsyncClient) or `run_in_threadpool`.

## Project structure (FastAPI)
```
app/
  main.py        api/routers/   core/{config.py,security.py}
  domain/        services/      repositories/   schemas/ (Pydantic)
  db/{models.py,session.py,migrations (Alembic)}
tests/
```
Settings via pydantic-settings; dependency injection via `Depends`; lifespan events for pools.

## Background & async work
Celery (Redis/RabbitMQ/SQS), RQ, Dramatiq, arq, or cloud queues + workers; FastAPI `BackgroundTasks` only
for trivial fire-and-forget.

## Data access
SQLAlchemy 2.x (typed, async), Alembic migrations, connection pool sizing per worker, avoid N+1
(`selectinload`), Django ORM `select_related`/`prefetch_related`.

## Performance
orjson responses, Pydantic v2 (Rust core), caching (Redis), pagination, gzip/brotli at proxy, profile
with py-spy/Scalene, load test with Locust/k6.

## Security
OAuth2/OIDC (Authlib), JWT validation (PyJWT with alg pinning), password hashing (argon2/bcrypt), input
validation via Pydantic, parameterized queries (ORM), Bandit/Semgrep for SAST, pip-audit/Mend for SCA,
secrets via environment/secret managers, CORS allowlist, rate limiting (slowapi/gateway).

## Deployment
Containers (slim base, non-root, multi-stage with uv), Lambda (Mangum adapter / Lambda Web Adapter;
Powertools for AWS Lambda), Cloud Run, Azure Container Apps/Functions.

## Interview angles
GIL and concurrency choices; async pitfalls; scaling FastAPI for LLM streaming (SSE, async clients,
timeouts, backpressure).
