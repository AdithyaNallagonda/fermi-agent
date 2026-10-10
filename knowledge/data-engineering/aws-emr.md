# Amazon EMR
Last reviewed: 2026-10 ⚠️ EMR 7.x releases (Spark 3.5.x); verify latest

## Deployment options
| Option | Use when | Notes |
|---|---|---|
| EMR on EC2 | Long-running/shared clusters, full control, many frameworks (Spark, Hive, Trino, HBase, Flink, Hudi) | Primary/core/task nodes; instance fleets; Spot for task nodes |
| EMR on EKS | Spark on shared Kubernetes platform, multi-tenancy | Virtual clusters → namespaces; job templates |
| EMR Serverless | Serverless Spark/Hive jobs, no cluster mgmt | Pre-initialized capacity for low startup latency; max capacity limits |
| EMR Studio | Notebooks/IDE | |

## Cluster design (EC2)
- Primary node (3 for HA), **core** nodes (HDFS + compute — avoid Spot for core), **task** nodes (compute
  only — Spot-friendly).
- Instance fleets with diversified instance types & allocation strategy (price-capacity-optimized).
- **Managed scaling** (min/max units, Spot/On-Demand limits). Graviton (m7g/r7g) for price-performance.
- Storage: S3 as data lake (EMRFS / S3A), HDFS only for intermediate data; EBS sizing for shuffle.
- Transient clusters per job (ephemeral) vs persistent shared clusters.

## Spark tuning on EMR
`maximizeResourceAllocation` (single big job) vs manual executor sizing; EMR Spark runtime optimizations
are on by default; S3-optimized committer for Parquet writes; dynamic allocation; AQE; see
`apache-spark.md`.

## Security
Security configurations (at-rest S3/local disk encryption, in-transit TLS), Kerberos, Lake Formation
integration for fine-grained access, runtime roles (per-step IAM roles), private subnets, Block Public
Access for EMR.

## Cost levers
Spot for task nodes (and Serverless doesn't use Spot), Graviton, managed scaling, transient clusters,
auto-termination idle timeout, right-size shuffle storage, Savings Plans for steady EC2.

## Observability
Spark History Server (persistent app UI), CloudWatch metrics, YARN ResourceManager, Ganglia (legacy) →
CloudWatch agent/Prometheus, step logs in S3.

## Interview angles
Glue vs EMR vs EMR Serverless; handling Spot interruptions (task nodes only, retries, graceful
decommissioning); multi-tenant Spark on EKS.
