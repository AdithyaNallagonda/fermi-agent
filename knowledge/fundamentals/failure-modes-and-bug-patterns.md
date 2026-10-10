# Failure Modes & Hard-to-Find Bug Patterns (diagnostic signatures)
Last reviewed: 2026-10 | Load when: debugging, incidents, RCA (`instructions/root-cause-analysis.md`).
Use as **hypothesis generators**, never as conclusions — each pattern lists the signature to look for and the check
that confirms it. Numbers marked [V] were verified on vendor docs 2026-10-10.

## Network & connections
| Pattern | Signature | Confirming check |
|---|---|---|
| **Idle-timeout mismatch** (pooled/keep-alive connection reused after a middlebox dropped it) | Intermittent `ECONNRESET` / "connection reset by peer" / "underlying connection was closed" on the **first request after idle**; fine under steady load | Compare idle gaps vs timeouts: AWS NAT GW 350 s, sends RST on resume [V]; ALB default 60 s [V]; Azure LB/NAT GW default 4 min, Azure NAT GW drops **silently** [V]; GCP Cloud NAT established TCP 1200 s [V]. Fix: pool max-idle/TTL < smallest timeout, or TCP keepalive below it |
| **Backend keep-alive < LB idle timeout** | Sporadic HTTP 502 at ALB/proxy, no app error logged | Server keep-alive timeout must exceed LB idle timeout [V AWS docs]; check access logs for 502 with `target_processing_time` patterns |
| **SNAT / ephemeral-port exhaustion** | Outbound connect timeouts under load, only from some instances; many `TIME_WAIT` | Azure "SNAT connection count — Failed" metric; `ss -s`; fix with connection reuse/pooling, more IPs, NAT gateway |
| **conntrack table full** (Linux/K8s nodes) | Random packet drops, `nf_conntrack: table full, dropping packet` in dmesg | `conntrack -S`, `sysctl net.netfilter.nf_conntrack_max` |
| **MTU / PMTUD black hole** | Small requests work, large responses/TLS handshakes hang (VPN, overlay, tunnels) | `ping -M do -s <size>`; check ICMP "frag needed" blocked; clamp MSS |
| **DNS caching / TTL** | After failover/IP change, some clients keep hitting the old IP for minutes/hours | Client DNS cache: JVM `networkaddress.cache.ttl`, connection pools holding resolved IPs, OS/nscd caches; compare resolved IPs per host |
| **K8s DNS `ndots:5` amplification** | Slow external lookups, high CoreDNS QPS, intermittent NXDOMAIN latency | Inspect `/etc/resolv.conf` in pods; use FQDN with trailing dot or tune `ndots` |
| **Asymmetric routing / stateful firewall** | SYN reaches server, replies dropped; works from some subnets | Compare route tables both directions; firewall/appliance mode on TGW |
| **NACL ephemeral ports** (stateless) | Inbound works, responses blocked | NACL outbound/inbound rules for 1024–65535 |
| **TLS issues** | Fails for some clients only | Expired intermediate, missing chain, SNI mismatch, TLS version/cipher policy, clock skew; `openssl s_client -connect host:443 -servername host -showcerts` |

## Timeouts, retries & distributed systems
| Pattern | Signature | Confirming check |
|---|---|---|
| **Timeout inversion** (caller timeout ≤ callee's) | Work completes downstream but caller already gave up → duplicates, orphaned work | Map timeouts per hop (client → gateway (API GW 29 s default [V]) → service → DB); each layer's timeout must be shorter than its caller's |
| **Retry storm / metastable failure** | Small blip becomes sustained outage; load stays high after root trigger is gone | Retry counts per layer multiply (3×3×3 = 27×); check retry budgets, jitter, circuit breakers |
| **Hidden SDK retries** | Latency spikes with no errors logged | SDK default retries on throttling (e.g., 429/ThrottlingException); enable SDK debug/metrics |
| **Non-idempotent retries** | Duplicate orders/charges/emails | Missing idempotency keys/conditional writes; correlate by request ID |
| **Clock skew** | JWT `nbf`/`exp` failures, signature errors (SigV4 "RequestTimeTooSkewed"), out-of-order events, wrong TTL expiry | Compare host clocks; NTP/chrony status |
| **Time zone / DST / leap-day** | Bugs on specific dates/hours, off-by-one-day reports | Grep for local-time arithmetic; test at DST boundaries; store UTC |
| **Read-after-write on replicas / eventual consistency** | "Saved but not showing", intermittent | Reads routed to lagging replicas or GSIs; check replica lag at failure time |
| **Cache stampede / stale cache** | Periodic DB spikes at TTL boundaries; stale data after updates | Synchronized TTLs, invalidation order (update DB then delete cache), race windows |
| **Message ordering / duplicates** | Rare wrong state; "impossible" transitions | At-least-once delivery, parallel consumers per key, rebalances; check partition/group keys and dedup |
| **Poison message / DLQ silently filling** | Throughput drops, partition stuck, or messages "lost" | Consumer lag per partition, DLQ depth alarms |
| **Consumer rebalance storms** (Kafka) | Lag spikes, duplicate processing every few minutes | `max.poll.interval.ms` exceeded by slow processing; rebalance logs |
| **Partial failure in multi-step workflow** | Inconsistent state across services | Missing saga compensation/outbox; dual writes |
| **Split brain** | Two primaries, divergent data after network partition | Quorum/fencing config, failover logs |

## Databases (see `databases/dba-diagnostics-cheatsheet.md`)
Plan regression after stats refresh/parameter sniffing (same query, different speed by parameter) · stale
statistics after bulk load · lock escalation / long transaction blocking (idle-in-transaction sessions) · deadlocks
from inconsistent access order · implicit type conversion disabling index · N+1 queries from ORM · connection-pool
exhaustion (pool size × instances > DB max connections) · **connection storm after failover** (all clients reconnect
at once; DNS cached old endpoint) · Postgres transaction-ID wraparound risk / autovacuum starvation · inactive
replication slot retaining WAL → disk full · hot partition/key in DynamoDB/Cosmos (throttling on one key while
table-level capacity looks fine) · sequence/identity exhaustion (INT overflow at 2,147,483,647) · collation/case
sensitivity mismatches between environments.

## Application code
Race conditions / check-then-act (TOCTOU) · thread-pool starvation from sync-over-async (.NET `.Result`/`.Wait()`)
or blocking calls in event loops (Node/Python asyncio) · memory leaks (event handlers, caches without bounds,
closures, static collections) · GC pauses (latency spikes with no load change) · resource leaks (unclosed
connections/streams/file handles) · integer overflow, floating-point money · Unicode normalization/encoding/BOM,
locale-dependent parsing (decimal comma, Turkish-I) · off-by-one in pagination with concurrent inserts (use
keyset pagination) · null/undefined in rarely-hit branches · feature-flag combinations never tested · config
differences between environments (env vars, secrets rotated, defaults changed by library upgrade) · dependency
upgrade behavior changes (check changelogs for "breaking"/default changes).

## Kubernetes & containers
OOMKilled (exit code 137) when memory limit < peak · CPU throttling with CPU limits (latency spikes at low average
CPU; check `container_cpu_cfs_throttled_*`) · liveness probe killing slow-starting pods (use startupProbe) ·
readiness probe passing before dependencies ready · `latest` tag drift / image pull failures · node pressure
evictions · PodDisruptionBudget blocking drains · graceful shutdown missing (SIGTERM ignored; in-flight requests
dropped during rollouts → add preStop + terminationGracePeriod) · NetworkPolicy default-deny side effects ·
ingress-nginx retired (Mar 2026) → unpatched CVEs.

## Cloud & IAM
AccessDenied from SCP/RCP/permission boundary/session policy/resource policy (not the identity policy you're
looking at) — read the full error and evaluate all policy types · IAM changes are eventually consistent (brief
failures right after creation) · KMS key policy or grant missing for cross-account · service quotas/throttling
(Lambda concurrency, API rate limits) · VPC Lambda without NAT/endpoint for AWS APIs · S3 bucket policy denies via
VPC endpoint conditions · region/partition mismatch · expired credentials/certificates/secrets after rotation ·
services moved to maintenance/deprecated (check lifecycle tables in cloud files).

## Frontend
CORS failure is often a **preflight** (OPTIONS) problem, or an error response missing CORS headers · stale
`index.html`/service worker serving old bundle after deploy (chunk-load errors) · hydration mismatch (SSR vs client
differences: dates, random IDs, locale) · cache headers on HTML vs hashed assets · third-party script failures ·
mixed content · cookie `SameSite`/`Secure` changes breaking auth flows · browser-specific APIs.

## CI/CD, Terraform & deployments
See the dedicated catalog `devops/pipeline-and-iac-failure-modes.md` (state locks, stale plans, unexpected
replacements, OIDC subject mismatches, swallowed exit codes, cache poisoning, rollout hangs, and more).

## Data pipelines
Late/duplicate data on reruns (non-idempotent writes) · schema drift upstream · timezone partition boundaries ·
small-files explosion slowing jobs · job bookmarks/watermarks skipping or reprocessing data · silent truncation/
type coercion · upstream partial files picked up before completion.

## Universal triage questions (the hawk-eye list)
What changed? · What's different between failing and working cases (user, region, AZ, node, version, payload,
time)? · Is it time-correlated (idle periods, cron, TTL, DST, cert expiry)? · Does it scale with load or with idle?
· Which layer's timeout/limit/default is closest to the symptom's numbers? · Is the error message from the layer
you think it is? · What does the system do on the *second* attempt? · What assumption are we making that's never
been tested?
