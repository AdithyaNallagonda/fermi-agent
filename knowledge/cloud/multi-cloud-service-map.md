# Multi-Cloud Service Map
Last reviewed: 2026-10 ⚠️ names change; verify

| Capability | AWS | Azure | GCP |
|---|---|---|---|
| VMs | EC2 | Virtual Machines | Compute Engine |
| Autoscaling groups | Auto Scaling Groups | VM Scale Sets | Managed Instance Groups |
| Serverless functions | Lambda | Functions | Cloud Run functions |
| Serverless containers | Fargate, ECS Express Mode (App Runner in maintenance) | Container Apps | Cloud Run |
| Kubernetes | EKS | AKS | GKE |
| Object storage | S3 | Blob Storage / ADLS Gen2 | Cloud Storage |
| Block storage | EBS | Managed Disks | Persistent Disk / Hyperdisk |
| File storage | EFS / FSx | Azure Files / NetApp Files | Filestore |
| Managed relational | RDS / Aurora | Azure SQL / PostgreSQL & MySQL Flexible | Cloud SQL / AlloyDB |
| Global relational | Aurora DSQL / Aurora Global DB | Cosmos DB for PostgreSQL (Citus) / SQL Hyperscale geo-replicas | Spanner |
| Key-value / document | DynamoDB / DocumentDB | Cosmos DB | Firestore / Bigtable |
| Wide column | Keyspaces | Cosmos DB Cassandra / Managed Instance for Cassandra | Bigtable |
| In-memory | ElastiCache / MemoryDB (Valkey) | Azure Managed Redis (Azure Cache for Redis retiring 2027/2028) | Memorystore (Valkey/Redis) |
| Search | OpenSearch Service | Azure AI Search | Vertex AI Search / (Elastic on GCP) |
| Data warehouse | Redshift | Fabric Warehouse / Synapse | BigQuery |
| Spark | EMR / Glue | Fabric / Synapse Spark / Databricks / HDInsight (legacy) | Dataproc |
| ETL/integration | Glue | Data Factory | Dataflow / Data Fusion |
| Streaming | Kinesis / MSK | Event Hubs | Pub/Sub / Managed Kafka |
| Queue | SQS | Service Bus / Storage Queues | Pub/Sub / Cloud Tasks |
| Pub/sub / event routing | SNS / EventBridge | Service Bus topics / Event Grid | Pub/Sub / Eventarc |
| Workflow | Step Functions | Logic Apps / Durable Functions | Workflows |
| Airflow | MWAA | Data Factory Workflow Orchestration Manager / Fabric | Cloud Composer |
| API gateway | API Gateway | API Management | API Gateway / Apigee |
| CDN | CloudFront | Front Door | Cloud CDN / Media CDN |
| DNS | Route 53 | Azure DNS / Traffic Manager | Cloud DNS |
| Global L7 LB | CloudFront + ALB / Global Accelerator | Front Door | Global External Application LB |
| Regional L7 LB | ALB | Application Gateway | Regional Application LB |
| L4 LB | NLB | Load Balancer | Network LB |
| Private service access | PrivateLink | Private Link | Private Service Connect |
| Hub networking | Transit Gateway / Cloud WAN | Virtual WAN / hub-spoke | NCC / Shared VPC |
| Dedicated link | Direct Connect | ExpressRoute | Cloud Interconnect |
| WAF | AWS WAF | Azure WAF | Cloud Armor |
| Identity (workforce) | IAM Identity Center | Entra ID | Cloud Identity |
| Customer identity | Cognito | Entra External ID | Identity Platform |
| Secrets | Secrets Manager | Key Vault | Secret Manager |
| KMS | KMS / CloudHSM | Key Vault / Managed HSM | Cloud KMS / HSM |
| CSPM / threat detection | Security Hub / GuardDuty | Defender for Cloud | Security Command Center |
| SIEM | Security Lake (+ partner) | Sentinel | Google SecOps |
| Policy guardrails | SCPs / RCPs / Config | Azure Policy | Organization Policy |
| IaC native | CloudFormation / CDK | ARM / Bicep | Infrastructure Manager (Terraform) |
| Monitoring | CloudWatch / X-Ray | Azure Monitor / App Insights | Cloud Monitoring / Trace |
| GenAI platform | Bedrock / AgentCore | Microsoft Foundry (ex-Azure AI Foundry) | Gemini Enterprise Agent Platform (ex-Vertex AI) |
| Agent runtime | AgentCore Runtime / harness | Foundry Agent Service (hosted agents) | Agent Engine |
| Managed MCP tool hub | AgentCore Gateway | Foundry Toolboxes | Agent Platform tools / API registry ⚠️ |
| AI coding assistant | Kiro (Q Developer EOS Apr 2027) | GitHub Copilot | Gemini Code Assist |
| ML platform | SageMaker AI | Azure ML | Gemini Enterprise Agent Platform (Vertex AI) |
| Vector search | OpenSearch, Aurora pgvector, S3 Vectors, MemoryDB | AI Search, Cosmos DB, PostgreSQL pgvector | Vertex AI Vector Search, AlloyDB, BigQuery |

## Multi-cloud strategy notes
- Reasons that justify multi-cloud: regulatory/sovereignty, M&A, best-of-breed services, negotiating
  leverage, customer-mandated cloud. "Avoid lock-in" alone rarely justifies the cost.
- Patterns: per-workload cloud choice (most common), portability layer (Kubernetes, Terraform, OTel,
  Postgres, Kafka), active-active across clouds (rare, expensive).
- Watch: egress costs, identity federation, network interconnect (cross-cloud interconnects, e.g., AWS
  Interconnect – multicloud ⚠️ preview/GA status), skills dilution, duplicated security tooling.
