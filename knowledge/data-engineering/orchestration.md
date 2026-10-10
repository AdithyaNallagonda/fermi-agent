# Workflow Orchestration
Last reviewed: 2026-10 — Apache Airflow **3.3** (Jul 2026; 3.3.2 Sep 2026). Airflow 3.x: new React UI, DAG
versioning, Task SDK / task execution API (remote execution), assets (renamed datasets) with event-driven
scheduling, backfills as first-class. Airflow 2.x reached EOL on 22 Apr 2026 (Astronomer supports it on Astro to Apr 2027); check MWAA/Composer supported versions.

## Options
| Tool | Strengths | Use when |
|---|---|---|
| Apache Airflow (MWAA, Cloud Composer, Astronomer) | Huge operator ecosystem, Python DAGs, scheduling/backfills | Data pipelines with many systems |
| AWS Step Functions | Serverless state machines, 200+ service integrations, Standard (long, exactly-once) vs Express (high-volume, at-least-once) | AWS-native workflows, sagas, event-driven |
| Azure Data Factory / Fabric Data Factory | Low-code pipelines, 90+ connectors, integration runtime (self-hosted for on-prem) | Microsoft estates |
| Durable Functions / Logic Apps | Code / low-code workflows | Azure app workflows |
| GCP Workflows / Cloud Composer | Serverless / Airflow | GCP |
| Dagster | Asset-oriented, strong typing/testing, lineage | Modern data platforms |
| Prefect | Pythonic, dynamic flows | Python-heavy teams |
| Temporal | Durable execution for application workflows (code-first) | Long-running business processes, sagas |
| dbt (Core/Cloud) | SQL transformation DAGs, tests, docs | Warehouse transformations (orchestrated by the above) |

## Principles
- Tasks idempotent and atomic; outputs keyed by logical date/partition.
- Orchestrator orchestrates — heavy compute runs elsewhere (Spark, warehouse, containers).
- Retries with backoff; timeouts; SLAs/alerts; sensors sparingly (use deferrable operators/events).
- Data-aware scheduling (Airflow assets/datasets, Dagster assets) over cron chains.
- Secrets via backend (Secrets Manager/Key Vault), not in variables/DAG code.
- CI/CD for DAGs: lint, import tests, unit tests, deploy via Git sync / S3 (MWAA).
- Backfill strategy defined upfront; catchup off unless intended.

## Interview angles
Airflow vs Step Functions (data pipelines vs app/service orchestration); designing idempotent daily
pipelines with late data; handling partial failures and reruns.
