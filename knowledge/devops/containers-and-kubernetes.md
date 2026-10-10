# Containers & Kubernetes
Last reviewed: 2026-10 — Kubernetes 1.35 (Dec 2025) widely available; ~3 minor releases/year; verify EKS/AKS/GKE
supported versions and extended-support pricing.

## ⚠️ Ingress NGINX is retired (verified: kubernetes.io blog, Nov 2025 & Jan 2026)
Best-effort maintenance ended **March 2026** — no further releases or security fixes. Existing installs keep
running but are a growing CVE risk. Migrate to **Gateway API** (GatewayClass/Gateway/HTTPRoute; role-oriented,
multi-tenant, more expressive) using **ingress2gateway 1.0** (released 20 Mar 2026). Implementations: AWS Load
Balancer Controller (Gateway API GA), Envoy Gateway, Istio, Cilium, NGINX Gateway Fabric, Kong, Traefik, GKE
Gateway, Application Gateway for Containers (AKS). Treat any design or exam answer that installs ingress-nginx as
outdated.

## Containers
Images: multi-stage builds, minimal bases (distroless/chiseled/Alpine with caution/Wolfi), non-root,
pinned digests, SBOM + signing (cosign), vulnerability scanning (Trivy, Inspector, Defender, Mend).
One process per container; config via env/secrets; health endpoints; graceful shutdown on SIGTERM.

## Kubernetes core
Pods, Deployments (stateless), StatefulSets (stable identity/storage), DaemonSets, Jobs/CronJobs,
Services (ClusterIP/NodePort/LoadBalancer), Ingress → **Gateway API** (successor; ingress-nginx retired Mar 2026), ConfigMaps/Secrets (use External Secrets Operator / CSI driver with cloud vaults),
PersistentVolumes/StorageClasses (CSI), Namespaces, RBAC, NetworkPolicies, PodDisruptionBudgets,
resource requests/limits, probes (startup/readiness/liveness).

## Scaling
- **HPA** (CPU/memory/custom metrics), **KEDA** (event-driven: queue length, Kafka lag), VPA
  (recommendations/in-place resize ⚠️).
- Node autoscaling: **Karpenter** (fast, bin-packing, Spot diversification; EKS Auto Mode builds on it),
  Cluster Autoscaler, GKE Autopilot / AKS Node Auto-Provisioning.
- Requests drive scheduling; set them from real usage; avoid CPU limits for latency-sensitive services
  (throttling) — debated; memory limits = requests for predictability.

## Managed offerings
| | EKS | AKS | GKE |
|---|---|---|---|
| Opinionated mode | EKS Auto Mode | AKS Automatic | GKE Autopilot |
| Identity | EKS Pod Identity / IRSA | Workload Identity (Entra) | Workload Identity Federation |
| Networking | VPC CNI (pod IPs from VPC), prefix delegation | Azure CNI Overlay / Cilium | Dataplane V2 (Cilium) |

## Platform add-ons
GitOps (Argo CD, Flux), service mesh (Istio ambient mode, Linkerd, Cilium service mesh) for mTLS/traffic
management, policy (Kyverno, OPA Gatekeeper), observability (Prometheus, OTel Collector, Grafana),
cert-manager, external-dns, Velero backups.

## Security
Pod Security Standards (restricted), no privileged pods, read-only root FS, seccomp, network policies
default deny, image admission (signature verification), RBAC least privilege, runtime detection (Falco,
GuardDuty EKS Runtime, Defender for Containers), private API endpoint, secrets encryption with KMS.

## When NOT to use Kubernetes
Small teams/few services → ECS/Fargate, Cloud Run, Container Apps, App Service. K8s pays off with a
platform team and many services/tenants.

## Interview angles
Readiness vs liveness; zero-downtime deploys (rolling with maxSurge/maxUnavailable, PDBs, preStop
hooks); scaling on queue depth (KEDA); multi-tenancy (namespaces vs clusters).
