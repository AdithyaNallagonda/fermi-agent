# Microsoft Azure — Core Services & Selection
Last reviewed: 2026-10 ⚠️ verify with `microsoft-learn` MCP (names/SKUs change often)

## Structure
Entra ID tenant → Management groups → Subscriptions → Resource groups → Resources. Regions with
Availability Zones (most major regions have 3). India: Central India (Pune, AZs), South India (Chennai),
West India (Mumbai), Jio India regions. Azure Landing Zones (CAF) with Azure Policy guardrails.

## Compute selection
| Service | Use when |
|---|---|
| Azure Functions (Flex Consumption / Premium / Dedicated) | Event-driven serverless; Durable Functions for workflows |
| Azure Container Apps | Serverless containers, microservices, KEDA scaling, Dapr; scale to zero |
| AKS | Full Kubernetes; AKS Automatic for opinionated managed mode |
| App Service | Web apps/APIs (.NET, Java, Node, Python), deployment slots |
| Virtual Machines / VMSS | Lift-and-shift, licensing, custom |
| Azure Batch | HPC/batch |
| Azure Spring Apps | ⚠️ being retired — migrate to Container Apps/AKS |

## Storage
Blob Storage (Hot/Cool/Cold/Archive; ADLS Gen2 hierarchical namespace for analytics), Azure Files,
Managed Disks (Premium SSD v2, Ultra), Azure NetApp Files. Redundancy: LRS, ZRS, GRS, GZRS, RA-GZRS.

## Databases
Azure SQL Database (General Purpose/Business Critical/Hyperscale; serverless), SQL Managed Instance,
SQL Server on VMs, Azure Database for PostgreSQL Flexible Server, Azure Database for MySQL Flexible
Server, Cosmos DB (NoSQL, MongoDB RU & vCore, Cassandra, Gremlin, Table, PostgreSQL), **Azure Managed Redis**
(Redis Enterprise-based; Azure Cache for Redis Enterprise tiers retire 31 Mar 2027, Basic/Standard/Premium retire
30 Sep 2028; new customers blocked since 1 Apr 2026), Azure Data Explorer (Kusto).

## Integration
Service Bus (queues/topics, sessions, transactions), Event Grid (event routing, MQTT), Event Hubs
(Kafka-compatible streaming), Logic Apps (integration workflows), API Management, Durable Functions.

## Networking (see `networking/azure-networking.md`)
VNet, NSGs, ASGs, Azure Firewall, hub-spoke / Virtual WAN, Private Link/Endpoints, Front Door,
Application Gateway (WAF), Load Balancer, Traffic Manager, ExpressRoute, VPN Gateway, Azure DNS (Private
Resolver), Bastion.

## Security & identity
Entra ID (Conditional Access, PIM, managed identities, workload identity federation), Key Vault
(Managed HSM), Defender for Cloud (CSPM + workload protections), Microsoft Sentinel (SIEM), Azure Policy,
Purview (governance/DLP).

## AI & data
**Microsoft Foundry** (formerly Azure AI Foundry/Azure AI Studio): 10,000+ models (Microsoft, OpenAI, Anthropic,
Meta…), **Foundry Agent Service** (prompt agents, voice agents, hosted agents, Toolboxes as managed MCP endpoints,
workflows, A2A, Entra agent identity, agent optimizer), observability/evaluations, Foundry control plane; classic
agents retire 31 Mar 2027), Azure AI Search (vector + hybrid + semantic ranker), AI services (Document
Intelligence, Speech, Vision, Content Safety), Azure Machine Learning, Microsoft Fabric (OneLake,
Data Factory, Data Engineering, Warehouse, Real-Time Intelligence, Power BI), Databricks, Synapse
(legacy path → Fabric).

## Cost levers
Reservations, Azure Savings Plan for compute, Azure Hybrid Benefit (Windows/SQL licenses), Spot VMs,
dev/test pricing, autoscale, Cost Management + budgets + Advisor.

## Exam/interview traps
Managed identity over secrets; Private Endpoint vs Service Endpoint (PE gives private IP, works cross-
region/on-prem); Front Door (global L7 + WAF + CDN) vs Traffic Manager (DNS) vs App Gateway (regional L7)
vs Load Balancer (regional L4); Business Critical tier has built-in read replica; GZRS for zone+region
resilience.

## Enterprise architect lens
Azure landing zones (platform vs workload LZs; Corp/Online/Local archetypes; Sandbox/Decommissioned) deployed via
accelerators (Bicep AVM or Terraform) — see `enterprise/landing-zones-and-cloud-governance.md`; Azure Policy
initiatives at management groups; Entra ID + PIM + Conditional Access as the security perimeter; Microsoft
Foundry projects attached to workload LZs with private networking; Purview for data governance; MACC commitments
and Azure Hybrid Benefit managed centrally; plan migrations off retiring services (Azure Cache for Redis, Foundry
classic agents, Spring Apps). India in-country DR: Central India ↔ South India.
