# AWS — Core Services & Selection
Last reviewed: 2026-10 ⚠️ verify service limits/pricing/GA via `aws-docs` / `aws-knowledge` MCP

## Global structure
Regions → AZs (≥ 3 per region, isolated, < 2 ms apart) → Local Zones / Wavelength / Outposts.
India regions: **ap-south-1 (Mumbai)**, **ap-south-2 (Hyderabad)**. Organizations → OUs → accounts;
Control Tower landing zone; SCPs and RCPs (resource control policies) as guardrails.

## Compute selection
| Service | Use when | Watch out |
|---|---|---|
| Lambda | Event-driven, spiky, < 15 min, stateless | Cold starts (SnapStart for Java/.NET/Python), concurrency limits, payload 6 MB sync |
| Fargate (ECS/EKS) | Containers without node mgmt | Higher unit cost than EC2 at steady state |
| ECS on EC2 | Simple container orchestration, cost control | Capacity providers |
| EKS | Kubernetes portability/ecosystem; large platform teams | Ops complexity; use EKS Auto Mode / Karpenter |
| EC2 (+ASG) | Full control, licensing, GPUs, steady load | Patching; use Graviton for ~20–40% price-performance |
| ECS Express Mode / Elastic Beanstalk | Simple web apps/APIs with minimal config | **App Runner is in maintenance (no new customers since 30 Apr 2026)** — don't recommend it |
| Batch | Batch jobs on EC2/Fargate/Spot | Queue design |

## Storage
S3 (11 9s durability; classes: Standard, Intelligent-Tiering, Standard-IA, One Zone-IA, Glacier Instant/
Flexible/Deep Archive; Express One Zone for single-digit-ms; S3 Tables (Iceberg); S3 Vectors),
EBS (gp3 baseline 3,000 IOPS/125 MB/s, io2 Block Express), EFS (NFS, multi-AZ), FSx (Windows, Lustre,
NetApp ONTAP, OpenZFS).

## Databases (see `databases/*`)
Aurora (MySQL/PostgreSQL; Serverless v2; Global Database; I/O-Optimized), RDS (incl. SQL Server/Oracle/
Db2), Aurora DSQL (distributed serverless SQL), DynamoDB, ElastiCache (Valkey/Redis OSS/Memcached),
MemoryDB, DocumentDB, Keyspaces, Neptune, Timestream, Redshift, OpenSearch Service/Serverless.

## Integration
SQS, SNS, EventBridge (bus, Pipes, Scheduler), Step Functions (Standard vs Express), MSK (provisioned/
serverless/Express brokers), Kinesis Data Streams/Firehose, Amazon MQ, AppSync (GraphQL/real-time),
API Gateway (REST vs HTTP API vs WebSocket).

## Networking (see `networking/aws-networking.md`)
VPC, TGW, Cloud WAN, PrivateLink, VPC Lattice, Route 53, CloudFront, Global Accelerator, DX, VPN, ALB/
NLB/GWLB.

## Security & identity
IAM (roles, policies, permission boundaries, ABAC), IAM Identity Center (SSO), Cognito, KMS, Secrets
Manager, Parameter Store, Certificate Manager, WAF, Shield, Firewall Manager, Network Firewall, GuardDuty,
Inspector, Macie, Security Hub, Detective, Security Lake, CloudTrail, Config, Verified Access, Verified
Permissions (Cedar).

## AI/ML (see `ai/cloud-ai-platforms.md`)
Bedrock (models, Knowledge Bases, Guardrails, **AgentCore** incl. harness; Agents Classic is in maintenance),
SageMaker AI (Unified Studio), Kiro (developer agentic IDE; replaces Q Developer), Rekognition/Textract/
Transcribe/Comprehend.

## Analytics
Athena, Glue, EMR, Redshift, Lake Formation, QuickSight, DataZone/SageMaker Catalog, Kinesis, MSK,
Managed Service for Apache Flink, MWAA.

## Cost levers
Savings Plans (Compute SP up to ~66%, EC2 Instance SP up to ~72%), Reserved Instances (RDS, ElastiCache,
Redshift, OpenSearch), Spot (up to 90%, interruptions), Graviton, right-sizing (Compute Optimizer),
S3 lifecycle/Intelligent-Tiering, NAT Gateway avoidance (VPC endpoints), cross-AZ data transfer
($0.01/GB each way), CloudWatch Logs retention, Cost Explorer, CUR 2.0, Budgets, Cost Anomaly Detection.

## Service lifecycle — avoid recommending these for new builds (verified 2026-10 via AWS "Service Availability Updates")
AWS now publishes lifecycle moves on the **AWS Product Lifecycle page** (subscribe to its RSS). "Maintenance" =
no new customers; "sunset" = end of operations announced.
| Status | Services (examples) | Recommend instead |
|---|---|---|
| Maintenance (from 30 Apr 2026) | **AWS App Runner**, CloudTrail Lake, AWS Audit Manager, Glue Ray jobs, SNS Message Data Protection, IoT FleetWise, ARC Readiness Check | ECS Express Mode / Fargate, Lambda; CloudTrail → Security Lake/Athena/CloudWatch; Glue Spark/EMR |
| Maintenance (2026) | **Bedrock Agents Classic**, **Amazon Q Business**, **Amazon Kendra**, Cognito Sync, Simple AD, myApplications, Service Catalog AppRegistry | **Bedrock AgentCore** (incl. harness); Bedrock Knowledge Bases / OpenSearch for enterprise search |
| Maintenance (from 7 Nov 2025) | CodeCatalyst, CodeGuru Reviewer, Fraud Detector, Glacier (legacy vault API — S3 Glacier storage classes are fine), S3 Object Lambda, Migration Hub, Application Discovery Service, Mainframe Modernization service, SSM Change Manager & Incident Manager | GitHub/GitLab + CodeBuild; S3 Glacier classes; AWS Transform for migration/mainframe |
| Sunset | AWS Proton, FinSpace, Lookout for Equipment, IoT Greengrass v1, RDS Custom for Oracle, WorkMail, WorkSpaces Thin Client | Platform engineering via Backstage/Service Catalog/CDK; RDS for Oracle / Oracle Database@AWS |
| Developer tooling | **Amazon Q Developer** IDE/CLI end of support **30 Apr 2027**, new sign-ups blocked since 15 May 2026 | **Kiro** (spec-driven agentic IDE/CLI) |
| Earlier | App Mesh (EOS 30 Sep 2026 ⚠️), QLDB (ended 31 Jul 2025) | VPC Lattice / ECS Service Connect / Istio; Aurora PostgreSQL with ledger tables |

## Exam/interview traps
"Least operational overhead" → serverless/managed; "most cost-effective" for steady → reserved/SP,
for interruptible → Spot; S3 cross-region replication isn't retroactive (use Batch Replication);
SQS FIFO throughput limits; Lambda in VPC needs NAT/endpoints for internet/AWS APIs; ALB does not give
static IPs (use NLB/Global Accelerator).

## Enterprise architect lens
Foundation via Control Tower + recommended OUs + data perimeters (see `enterprise/landing-zones-and-cloud-governance.md`);
enterprise discount program (EDP/PPA) and Savings Plans managed centrally; service allow-list driven by the
lifecycle table above (block maintenance/sunset services for new workloads via SCP); paved roads for compute
(Lambda, ECS/Fargate, EKS Auto Mode), data (Aurora, DynamoDB, S3 Tables/Iceberg), AI (Bedrock + AgentCore behind an
AI gateway); Well-Architected reviews (incl. GenAI and SaaS lenses) as release gates for Tier-1 workloads; India
residency via Region guardrails (ap-south-1 Mumbai + ap-south-2 Hyderabad for in-country DR).
