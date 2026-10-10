# Microsoft (Azure) Certifications
Last reviewed: 2026-10 (verified against learn.microsoft.com retired-exams page on 2026-10-10)
⚠️ Microsoft is reorganizing certs "for the AI era" — verify via `microsoft-learn` MCP before planning.

## What changed in 2026 (verified)
| Retired exam (date) | Replacement |
|---|---|
| AZ-204 Azure Developer Associate (31 Jul 2026) | **AI-200** → Azure AI Cloud Developer Associate |
| AI-102 Azure AI Engineer Associate (30 Jun 2026) | **AI-103** → Azure AI App and Agent Developer Associate |
| AZ-500 Azure Security Engineer Associate (31 Aug 2026) | **SC-500** → Cloud and AI Security Engineer |
| DP-100 Azure Data Scientist Associate (1 Jun 2026) | **AI-300** → MLOps Engineer Associate |
| AI-900 Azure AI Fundamentals (30 Jun 2026) | **AI-901** |
| PL-600 Power Platform Solution Architect Expert, MB-700 D365 F&O Solution Architect (30 Jun 2026) | **AB-100** recommended |
| AZ-800/801 Windows Server Hybrid Admin (30 Sep 2026) | AZ-802 |
| MS-900 (31 Mar 2026), MS-102 (retires 30 Nov 2026) | — |
| DP-203 (Mar 2025) | DP-700 Fabric Data Engineer |
New/beta: **DP-750** Azure Databricks Data Engineer Associate, **DP-800** SQL AI Developer Associate,
**AB-620** AI Agent Builder Associate, SC-730 Cybersecurity Business Professional. ⚠️ Check GA status of each.

## Certifications for architects (current)
| Cert | Exam | Notes |
|---|---|---|
| Azure Fundamentals | AZ-900 | Optional |
| Azure Administrator Associate | AZ-104 | **Prerequisite** for AZ-305 |
| **Azure Solutions Architect Expert** | AZ-305 (+ AZ-104) | Primary SA credential — unaffected by 2026 retirements |
| DevOps Engineer Expert | AZ-400 (+ AZ-104 or developer associate) | ⚠️ verify prerequisite now that AZ-204 retired |
| Azure Network Engineer Associate | AZ-700 | Hybrid networking |
| Cybersecurity Architect Expert | SC-100 | Zero trust/security strategy |
| Cloud and AI Security Engineer | SC-500 | Replaces AZ-500 |
| Azure AI App and Agent Developer | AI-103 | Foundry, agents, RAG — replaces AI-102 |
| Azure AI Cloud Developer | AI-200 | Replaces AZ-204 |
| Fabric Data Engineer / Analytics Engineer | DP-700 / DP-600 | |
| Azure Database Administrator | DP-300 | |
| Cosmos DB Developer Specialty | DP-420 | ⚠️ verify status |

## AZ-305 skill areas (verify weights)
Design identity, governance & monitoring solutions (25–30%) · Design data storage solutions (20–25%) · Design
business continuity solutions (15–20%) · Design infrastructure solutions (30–35%).
KB map: `cloud/azure.md`, `networking/azure-networking.md`, `databases/sql-server.md`, `databases/cosmos-db.md`,
`security/identity-and-access.md`, `fundamentals/reliability-and-resilience.md`.

## Suggested Azure SA path (2026)
AZ-104 → AZ-305 → specialize: AI-103 (AI architect), SC-100/SC-500 (security), AZ-700 (network), DP-700 (data).

## Resources & technique
Microsoft Learn learning paths, **free Practice Assessments**, exam sandbox, Applied Skills (hands-on; several
retired in 2026), Azure Architecture Center, Well-Architected Framework, Cloud Adoption Framework. Case-study items
hinge on one requirement; yes/no series can't be revisited. Traps: Private Endpoint vs Service Endpoint; Front Door vs
App Gateway vs Traffic Manager; SQL MI vs SQL DB; storage redundancy; RBAC vs Policy; managed identities.
Pearson VUE; pass 700/1000; role-based certs renew **free annually** via online assessment. No automatic migration
from retired to replacement certs.
