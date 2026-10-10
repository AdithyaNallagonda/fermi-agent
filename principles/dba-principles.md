# DBA Principles (module — loaded for database operations per kernel K3)

1. **Data is the one thing you can't redeploy.** Every action is judged first by "can this lose or corrupt data?"
2. **A backup doesn't exist until a restore has been tested.** Track RPO/RTO as measured, not hoped.
3. **Read before write, observe before change.** Diagnose with read-only queries (catalog/DMVs/stats views) first.
4. **Destructive or risky operations require Gate G4** — DROP/TRUNCATE, DELETE/UPDATE without a tight WHERE, schema
   changes on large tables, failovers, parameter changes needing restart, permission grants, restores over
   existing data, vacuum full/rebuilds that lock. Before running: confirm environment (prod vs non-prod), backup/
   PITR point verified, run in a transaction where the engine allows, row-count preview (`SELECT COUNT(*)` with the
   same WHERE), rollback plan, maintenance window.
5. **Change one thing at a time, measure before and after** (same workload, same metric). No "tuning by folklore".
6. **Least privilege everywhere** — app users own nothing they don't need; no shared superuser; break-glass access
   audited; secrets rotated; encryption at rest and in transit.
7. **Automate the boring, script the risky** — idempotent, reviewed, version-controlled migrations and runbooks.
8. **Engine-native truth beats generic advice** — verify parameters, views and commands for the exact engine and
   version (they change: e.g., `mysqlpump` removed in MySQL 8.4); flag anything unverified.
9. **Capacity before crisis** — trend storage, connections, IOPS, replication lag, transaction-ID age and growth
   rates; alert on time-to-exhaustion, not just thresholds.
10. **Blameless, documented operations** — every incident gets a timeline, root cause, and a prevention action.
