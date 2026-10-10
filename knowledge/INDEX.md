# Knowledge Index (router)

Load only the files a task needs. ⚠️ = contains volatile facts — verify live before quoting.
Token tip: `Grep` this file for task keywords instead of reading it whole; then read only needed sections of the hits.

## fundamentals/
| File | Load when |
|---|---|
| `fundamentals/system-design-fundamentals.md` | Any design/interview: scalability, latency numbers, estimation, LB, CAP/PACELC, consistency |
| `fundamentals/distributed-systems-patterns.md` | Replication, partitioning, consensus, sagas, outbox, CQRS, event sourcing, idempotency |
| `fundamentals/caching-strategies.md` | Cache patterns, invalidation, CDN, stampede protection |
| `fundamentals/messaging-and-streaming.md` | Queues vs logs, Kafka, SQS/SNS, EventBridge, Service Bus, Pub/Sub, delivery semantics |
| `fundamentals/api-design.md` | REST/gRPC/GraphQL/WebSockets, pagination, versioning, rate limiting, idempotency keys |
| `fundamentals/microservices-and-ddd.md` | Service boundaries, DDD, modular monolith, service mesh, migration (strangler) |
| `fundamentals/reliability-and-resilience.md` | SLOs, error budgets, DR strategies, multi-region, cell-based, chaos |
| `fundamentals/observability.md` | Logs/metrics/traces, OpenTelemetry, golden signals, alerting |
| `fundamentals/failure-modes-and-bug-patterns.md` | Debugging/RCA: signatures + confirming checks for hard bugs (timeouts, retries, DNS, SNAT, clocks, caches, DB, code, K8s, IAM, frontend, pipelines) |
| `fundamentals/classic-design-problems.md` | Interview problems cheat sheet (URL shortener, feed, chat, Uber, etc.) |

## cloud/
| File | Load when |
|---|---|
| `cloud/aws.md` ⚠️ | AWS core services & selection |
| `cloud/azure.md` ⚠️ | Azure core services & selection |
| `cloud/gcp.md` ⚠️ | GCP core services & selection |
| `cloud/multi-cloud-service-map.md` ⚠️ | Cross-cloud equivalents, multi-cloud strategy |
| `cloud/well-architected-and-finops.md` | Well-Architected pillars, landing zones, migration 7Rs, FinOps |

## networking/
| File | Load when |
|---|---|
| `networking/networking-fundamentals.md` | OSI, TCP/UDP/QUIC, TLS, DNS, HTTP/2/3, CDN, L4/L7 LB, anycast |
| `networking/aws-networking.md` ⚠️ | VPC, TGW, PrivateLink, Cloud WAN, Route 53, DX, egress costs |
| `networking/azure-networking.md` ⚠️ | VNet, hub-spoke, vWAN, Private Link, Front Door, ExpressRoute |
| `networking/gcp-networking.md` ⚠️ | Global VPC, Shared VPC, PSC, Cloud LB, Interconnect, NCC |

## databases/
| File | Load when |
|---|---|
| `databases/database-selection.md` | Choosing a datastore |
| `databases/dba-fundamentals.md` | Cross-engine DBA craft: indexing, optimization, concurrency, backup/PITR, HA/DR, scaling, monitoring |
| `databases/dba-diagnostics-cheatsheet.md` ⚠️ | Read-only diagnostic views/commands per engine (PG, MySQL, SQL Server, Oracle, Mongo, Cassandra, Redis, DynamoDB, Cosmos) |
| `databases/postgresql.md` | PostgreSQL, Aurora/AlloyDB/Azure Flexible, pgvector |
| `databases/mysql.md` | MySQL, Aurora MySQL, replication |
| `databases/sql-server.md` | MS SQL Server, Azure SQL, Always On |
| `databases/oracle.md` | Oracle DB, RAC, Exadata, migration off Oracle |
| `databases/newsql-distributed-sql.md` ⚠️ | Spanner, Aurora DSQL, CockroachDB, YugabyteDB, TiDB |
| `databases/dynamodb.md` ⚠️ | DynamoDB modeling, single-table, limits |
| `databases/cosmos-db.md` ⚠️ | Cosmos DB partitioning, RUs, consistency |
| `databases/mongodb.md` | MongoDB/Atlas/DocumentDB |
| `databases/cassandra-and-wide-column.md` | Cassandra, ScyllaDB, Keyspaces, Bigtable, HBase |
| `databases/redis.md` ⚠️ | Redis/Valkey, ElastiCache, MemoryDB, Azure Managed Redis, patterns |
| `databases/redshift.md` ⚠️ | Amazon Redshift |
| `databases/cloud-data-warehouses.md` ⚠️ | Snowflake, BigQuery, Synapse/Fabric, ClickHouse, Databricks SQL |

## search/
| File | Load when |
|---|---|
| `search/opensearch.md` ⚠️ | OpenSearch/Elasticsearch: indexing, sharding, relevance, vector & hybrid search, ops |

## data-engineering/
| File | Load when |
|---|---|
| `data-engineering/python-data-engineering.md` | Python for DE: pandas, Polars, PyArrow, PySpark, testing |
| `data-engineering/apache-spark.md` | Spark internals and tuning |
| `data-engineering/aws-glue.md` ⚠️ | Glue jobs, catalog, crawlers, DQ, cost |
| `data-engineering/aws-emr.md` ⚠️ | EMR on EC2/EKS/Serverless |
| `data-engineering/lakehouse-and-table-formats.md` | Iceberg/Delta/Hudi, medallion, Lake Formation, Athena |
| `data-engineering/orchestration.md` | Airflow/MWAA, Step Functions, ADF, Dagster |
| `data-engineering/streaming-and-cdc.md` | Kinesis, MSK, Flink, CDC (DMS/Debezium), zero-ETL |

## frontend/
| File | Load when |
|---|---|
| `frontend/frontend-system-design.md` | Rendering strategies, state, micro-frontends, FE interviews |
| `frontend/react.md` ⚠️ | React 19, Next.js, state, performance |
| `frontend/angular.md` ⚠️ | Angular signals, standalone, SSR, NgRx |
| `frontend/web-performance-and-security.md` | Core Web Vitals, caching, CSP, XSS/CSRF, a11y |

## design/
| File | Load when |
|---|---|
| `design/ux-research-and-interaction.md` | UX research methods, heuristics, laws of UX, interaction patterns, AI-native UX, dark patterns |
| `design/ui-visual-and-design-systems.md` | Visual hierarchy, type, color (OKLCH), tokens, components/states, platform systems, motion, design QA |
| `design/accessibility.md` ⚠️ | WCAG 2.2 AA (ISO/IEC 40500:2025), what's new in 2.2, EAA, India IS 17802/GIGW, Indic typography |
| `design/branding-logo-and-naming.md` | Brand strategy, logo types & craft, SVG rules, naming process & screening, naming conventions |
| `design/design-trends.md` ⚠️ | Liquid Glass, Material 3 Expressive, UI/brand trends 2025–26 and how to use them |

## backend/
| File | Load when |
|---|---|
| `backend/dotnet.md` ⚠️ | .NET / ASP.NET Core architecture & performance |
| `backend/python-backend.md` | FastAPI/Django, async, packaging, performance |

## devops/
| File | Load when |
|---|---|
| `devops/containers-and-kubernetes.md` | Docker, K8s, EKS/AKS/GKE, autoscaling, service mesh |
| `devops/terraform-deep-dive.md` ⚠️ | Terraform/OpenTofu in depth: state, refactoring blocks, modules, environments, testing, CI workflow, operations, version differences |
| `devops/cicd-pipeline-design.md` | Platform-agnostic pipeline design, platform concept map (GitHub Actions, Azure Pipelines, GitLab CI, Jenkins), speed, security, migration |
| `devops/pipeline-and-iac-failure-modes.md` | Diagnostic signatures for Terraform, CI/CD and deployment failures with confirming checks |
| `devops/multi-environment-deployment.md` | Environment topology, promotion, release ordering, rollout strategies, go/no-go, rollback, runbook |
| `devops/infrastructure-as-code.md` | Terraform/OpenTofu, CDK, Bicep, Pulumi, policy-as-code |
| `devops/cicd-and-release.md` | Pipelines, deployment strategies, GitOps, DORA |

## security/
| File | Load when |
|---|---|
| `security/ssdlc.md` | Secure SDLC program end-to-end |
| `security/sast-dast-sca-mend.md` ⚠️ | SAST, DAST, SCA (Mend), secrets, IaC, container scanning |
| `security/owasp.md` | OWASP Top 10 (2021/2025), API Top 10, ASVS, SAMM, LLM Top 10 |
| `security/cloud-security.md` | Cloud security architecture, CSPM, KMS, detection |
| `security/identity-and-access.md` | OAuth2/OIDC/SAML, JWT, mTLS, zero trust, workload identity |
| `security/ai-security.md` | Prompt injection, guardrails, MITRE ATLAS, NIST AI RMF, ISO 42001 |

## ai/
| File | Load when |
|---|---|
| `ai/llm-fundamentals.md` | Transformers, tokens, sampling, prompting, context, fine-tuning |
| `ai/rag-architecture.md` | RAG pipeline design, chunking, hybrid search, rerank, eval |
| `ai/vector-databases.md` ⚠️ | ANN indexes, pgvector, OpenSearch k-NN, Pinecone, S3 Vectors, etc. |
| `ai/model-hosting-and-inference.md` ⚠️ | GPUs, vLLM, quantization, batching, serving, cost |
| `ai/agentic-systems-and-mcp.md` ⚠️ | Agents, tools, MCP, A2A, memory, multi-agent patterns |
| `ai/mlops-and-llmops.md` | ML lifecycle, evals, monitoring, feature stores |
| `ai/bundled-tools.md` ⚠️ | Tools shipped with this agent: Azure DevOps, GitHub and draw.io MCP servers, Mermaid CLI helper, REA reverse engineering (opt-in) — usage, data handling, gates, pins |
| `ai/tooling-ecosystem-and-sources.md` ⚠️ | Trusted sources & commands for MCP servers, Claude Code plugins/skills/agents, extensions; supply-chain vetting |
| `ai/cloud-ai-platforms.md` ⚠️ | Bedrock/AgentCore, Microsoft Foundry, Gemini Enterprise Agent Platform (ex-Vertex AI) |

## enterprise/
| File | Load when |
|---|---|
| `enterprise/enterprise-architecture-practice.md` | TOGAF 10, capability maps, portfolio rationalization (TIME), EA governance, EA for AI |
| `enterprise/landing-zones-and-cloud-governance.md` | AWS multi-account OUs/Control Tower, Azure landing zones (CAF), GCP foundations, guardrails |
| `enterprise/multi-tenant-saas-architecture.md` | SaaS control/app plane, silo/pool/bridge, tenant isolation, metering, noisy neighbors |
| `enterprise/platform-engineering.md` | IDPs, golden paths, Team Topologies, CNCF platform maturity model |
| `enterprise/integration-architecture.md` | API-led connectivity, API governance, event-driven enterprise, SAP/mainframe/B2B, India rails |
| `enterprise/data-governance.md` | DAMA-DMBOK, data products & contracts, MDM styles, data quality, privacy engineering |
| `enterprise/regulatory-architecture.md` ⚠️ | DPDP Rules 2025 phases, CERT-In, RBI, SEBI, EU AI Act (Omnibus), PCI DSS 4.0.1, compliance patterns |

## delivery/
| File | Load when |
|---|---|
| `delivery/safe.md` ⚠️ | SAFe 6.0 |
| `delivery/scrum-and-agile.md` | Scrum Guide 2020, Kanban, estimation, metrics |
| `delivery/pmp-and-project-management.md` ⚠️ | PMBOK 7, PMP exam, EVM, risk |

## career/
| File | Load when |
|---|---|
| `career/india-solution-architect-market.md` ⚠️ | India SA job market, roles, comp, hiring process |
| `career/corporate-navigation-and-negotiation.md` | Negotiation, conflict, influence, politics |

## business/
| File | Load when |
|---|---|
| `business/entrepreneurship-and-idea-validation.md` | Idea validation, market gaps, MVP |
| `business/saas-monetization-and-pricing.md` | Pricing, unit economics, GTM, India specifics |

## certifications/
| File | Load when |
|---|---|
| `certifications/aws-certifications.md` ⚠️ | AWS cert paths and exam prep |
| `certifications/azure-certifications.md` ⚠️ | Microsoft certs |
| `certifications/gcp-certifications.md` ⚠️ | Google Cloud certs |
| `certifications/pm-agile-certifications.md` ⚠️ | PMP, CAPM, SAFe, PSM/CSM |
| `certifications/security-ai-k8s-certifications.md` ⚠️ | CISSP/CCSP/CSSLP, CKA/CKAD/CKS, Terraform, AI certs |

---
New knowledge file? Use `templates/knowledge-file-template.md` and add a row here.
