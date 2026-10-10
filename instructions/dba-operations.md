# Playbook: DBA Operations (platform-agnostic)

Principles: `principles/dba-principles.md`. Knowledge: `knowledge/databases/dba-fundamentals.md`,
`knowledge/databases/dba-diagnostics-cheatsheet.md`, plus the engine file (`databases/<engine>.md`).
If a database MCP/tool is connected (e.g., a Postgres query tool), use it **read-only** for diagnosis; any write →
Gate G4.

## Pick the track
| Track | Trigger |
|---|---|
| A. Performance troubleshooting | Slow queries, high CPU/IO, timeouts, lock waits, deadlocks |
| B. Health check / audit | Periodic review, inherited database, pre-go-live |
| C. Backup, recovery & DR design | New system, compliance, failed restore, ransomware readiness |
| D. HA & replication | Failover design, replica lag, split-brain risk |
| E. Schema change / migration / upgrade | DDL on big tables, version upgrades, engine/platform migration |
| F. Capacity & cost | Growth planning, right-sizing, licensing, managed vs self-managed |
| G. Security hardening | Least privilege, encryption, auditing, compliance |
| H. Incident response | Outage, corruption, runaway query, disk full, replication broken |

**Gate G1**: engine + exact version, managed service or self-hosted, environment (prod?), symptoms with timestamps,
recent changes, workload type (OLTP/OLAP/mixed), size, SLOs (RPO/RTO/latency). Don't guess engine-specific
syntax without the version.

## A. Performance — the method (USE + waits + top SQL)
(For incidents/bugs needing a formal RCA, run `instructions/root-cause-analysis.md` with this track as the DB lens.)
1. **Scope**: one query, one app, or whole instance? Since when? What changed (deploy, data volume, stats, plan,
   parameter, infra)?
2. **Resources (USE)**: CPU, memory, disk IOPS/throughput/latency, network, connections — saturated?
3. **Waits**: what are sessions waiting on (I/O, locks, latches, CPU, network, commit/log flush)?
4. **Top SQL** by total time (not just per-execution): `pg_stat_statements` / performance_schema digest / Query
   Store / AWR-ASH / profiler.
5. **Plan analysis**: actual vs estimated rows (stats problems), scans vs seeks, join order/type, sorts/spills,
   implicit conversions, parameter sensitivity, missing/unused indexes.
6. **Fix (least invasive first)**: rewrite query → index (covering/composite/partial) → statistics refresh →
   plan stabilization (plan guides/Query Store forcing/hints, with expiry) → config → schema/partitioning → hardware.
7. **Verify** with the same metric and workload; document; add a regression guard (alert or test).

## B. Health check (report as findings table)
Version/patch level & EOL · backups + last tested restore · HA/DR status & lag · storage growth & free space ·
bloat/fragmentation · stats freshness · unused & duplicate indexes · missing FK indexes · long-running/idle-in-
transaction sessions · top waits · error log anomalies · security (superusers, default accounts, public grants,
TLS, encryption, auditing) · configuration drift vs baseline · monitoring & alert coverage · transaction-ID/
sequence exhaustion risk.

## C. Backup, recovery & DR
Define RPO/RTO per database → choose: full + differential/incremental + log/WAL/binlog for PITR; snapshots
(crash-consistent vs application-consistent); logical dumps for portability (not primary DR at scale); cross-region
and cross-account copies; immutable/vault-locked backups against ransomware; encryption keys recoverable; retention
per regulation. **Schedule restore drills** and measure actual RTO. Runbooks for: PITR to timestamp, single-table
recovery, full-region failover.

## D. HA & replication
Choose sync vs async (RPO vs latency), quorum/witness to avoid split-brain, automatic vs manual failover, read
replicas & lag-aware routing, connection endpoints that move on failover, application retry semantics, fencing.
Test failover regularly; monitor lag in seconds and bytes.

## E. Schema changes, migrations, upgrades
- Zero-downtime DDL: **expand → migrate/backfill in batches → switch reads/writes → contract**; online DDL tools
  (`CREATE INDEX CONCURRENTLY`, gh-ost/pt-online-schema-change, online index rebuild, edition-based redefinition);
  lock timeouts set so DDL fails fast instead of blocking.
- Migrations as code (Flyway, Liquibase, Alembic, EF Core migrations, Sqitch) with review and rollback scripts.
- Version upgrades: read release notes/deprecations, compatibility checks (upgrade advisors), test on a restored
  prod copy, performance baseline comparison, blue/green where available, rollback plan.
- Platform migrations: assess (SCT/DMS Schema Conversion, Ora2Pg, Azure DMS), convert, CDC-based sync, validate
  (row counts, checksums), cutover runbook with go/no-go criteria.

## F. Capacity & cost
Trend storage/IOPS/CPU/connections; forecast to time-to-exhaustion; right-size instances & storage class (gp3
IOPS separate from size; provisioned IOPS only when needed); read replicas vs caching; archive/partition-drop
cold data; commitment pricing (RIs/savings plans) for steady fleets; license optimization (SQL Server editions,
Oracle core factors, BYOL vs included).

## G. Security hardening
Separate roles (owner, app read/write, read-only, migration, monitoring); no app use of superuser/sa/SYS;
password + IAM/Entra auth; TLS enforced; encryption at rest with CMK where required; row-level security/data
masking for sensitive data; auditing (pgAudit, SQL Server Audit, Oracle Unified Auditing, MySQL audit plugins);
network isolation (private subnets/endpoints); patch cadence; periodic access review. Map to compliance needs
(`enterprise/regulatory-architecture.md`).

## H. Incident response
Stabilize first (kill runaway sessions, add storage, fail over, throttle app) — each a G4-gated action unless the
user pre-authorized → preserve evidence (logs, stats snapshots) → communicate → root cause → prevention.

> **Audit checkpoint (D + E + B) — before giving commands or changes:** syntax valid for the stated engine/version
> (verify if unsure), destructive steps gated with backup + preview + rollback, impact on locks/replication
> considered, measurement plan defined.

## Final step — Adversarial audit (mandatory)
Tier: **Deep** for production changes, restores, failovers, security; Standard for advice-only. Apply §D (scripts
parse/run read-only where possible), §E (engine/version facts verified), §B (fix choice vs alternatives). Any
unverified command or parameter → tripwire STOP. End with the 🔍 audit summary.
