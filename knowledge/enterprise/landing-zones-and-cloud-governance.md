# Landing Zones & Cloud Governance (AWS · Azure · GCP)
Last reviewed: 2026-10 | Sources: AWS Organizations best practices & "Organizing your AWS environment using
multiple accounts" whitepaper; Microsoft Cloud Adoption Framework (Azure landing zones); Google Cloud
enterprise foundations blueprint. Load when: enterprise cloud foundations, governance, multi-account design.

## Principles (cloud-agnostic)
1. Account/subscription/project = **security, quota and billing boundary** → use many, organized by *controls
   needed*, not by org chart.
2. Separate production from non-production; separate platform (shared services) from workloads.
3. Guardrails are preventive (policies) + detective (config rules, CSPM) + responsive (auto-remediation).
4. Vend environments automatically (account/subscription vending) with baseline controls pre-applied.
5. Central identity, logging, security tooling, network hub, DNS, and tagging standards from day one.

## AWS
- **Single AWS Organization**; recommended OUs:
  | OU | Purpose |
  |---|---|
  | Security | Log archive account, security tooling/audit account (GuardDuty/Security Hub delegated admin) |
  | Infrastructure | Network hub (TGW/Cloud WAN, egress/inspection), shared services (DNS, directory, IPAM) |
  | Workloads (Prod / SDLC sub-OUs) | Application accounts per workload per environment |
  | Sandbox | Experimentation, disconnected from internal networks, budget caps |
  | Policy Staging | Test SCP/RCP changes before production |
  | Suspended | Closed/quarantined accounts |
  | Exceptions | Workloads needing deviations, with compensating controls |
  | Deployments | CI/CD tooling accounts |
  | Transitional / Individual Business Users | Acquisitions in transit; non-workload users |
- **Control Tower** (landing zone, controls library, Account Factory / AFT for Terraform), **SCPs** (max
  permissions for principals), **RCPs** (max permissions on resources — data perimeter), declarative policies,
  delegated administrators, IAM Identity Center, Organization-wide CloudTrail, AWS Config conformance packs,
  Security Hub, IPAM, tag policies, backup policies, Budgets per account.
- **Data perimeter** pattern: identity, resource and network perimeters with `aws:PrincipalOrgID`,
  `aws:ResourceOrgID`, `aws:SourceVpce` conditions.

## Azure (Cloud Adoption Framework — Azure landing zones)
- Two components: **platform landing zone** (shared governance, security, connectivity, identity, management)
  and **workload (application) landing zones** (subscriptions where workload teams deploy within guardrails).
- **Design areas**: A billing & Entra tenant · B identity & access · C resource organization · D/E network
  topology & connectivity · security · management · governance · platform automation & DevOps.
- **Management group hierarchy** (baseline): Intermediate root → **Platform** (Security, Management, Identity,
  Connectivity — each with its own subscription) · **Landing Zones** (**Corp** — hybrid-connected via hub;
  **Online** — internet-facing; **Local** — Azure Local/edge) · **Sandbox** · **Decommissioned**.
- Azure Policy initiatives assigned at management groups (deny/audit/deployIfNotExists), Defender for Cloud,
  Microsoft Sentinel, Purview; **Microsoft Foundry + Foundry IQ** shown as optional AI capability attached to
  workload landing zones; Agent 365/Entra/Purview as unified governance layer (2026 CAF).
- Implementation: **accelerators** (Bicep with Azure Verified Modules, or Terraform) vs custom build;
  subscription vending.

## Google Cloud (enterprise foundations blueprint)
Organization → folders (bootstrap, common/shared, environment folders production/non-production/development,
network) → projects; Shared VPC host projects per environment (or hub-and-spoke with NCC); Organization Policy
constraints (e.g., disable SA key creation, restrict resource locations to `asia-south1/2` for residency,
restrict public IPs), centralized logging sinks, Security Command Center, VPC Service Controls perimeters,
Terraform-based project factory, Cloud Identity groups.

## Cross-cloud governance essentials
| Area | Standard |
|---|---|
| Tagging | Mandatory: owner, cost-center, environment, data-classification, application-id; enforced by policy |
| Identity | One IdP (Entra/Okta) federated to all clouds; no local users; PIM/JIT |
| Logging | Org-wide, immutable, central account/subscription/project; retention per regulation (CERT-In: 180 days in India) |
| Network | Non-overlapping IP plan (IPAM), hub-and-spoke per cloud, central egress inspection, private endpoints |
| Data residency | Location policies (SCP region deny / Azure allowed locations / GCP resource locations) |
| FinOps | Budgets & anomaly alerts per account; showback; commitment management centrally |
| Exceptions | Time-bound, risk-accepted, in Exceptions OU/MG |

## Maturity path
Crawl: single org, a few accounts, SSO, org trail, budgets → Walk: Control Tower/ALZ accelerator, vending,
hub network, policy-as-code → Run: data perimeters, automated remediation, cell/workload isolation, compliance
evidence automation, AI landing zone patterns (model access via private endpoints, AI gateway in shared
services, agent identity governance).

## Interview angles
"Design the cloud foundation for a bank's GCC in India" → multi-account by controls, residency guardrails
(ap-south-1/2, Central India), central logging ≥ 180 days, hub-spoke with DX/ExpressRoute, data perimeters,
PIM, CSPM, regulator access provisions (RBI/SEBI), DR region within India.
