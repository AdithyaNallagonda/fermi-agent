# Enterprise Integration Architecture
Last reviewed: 2026-10 | Load when: connecting many systems (ERP/CRM/core banking/SaaS), API strategy, events,
iPaaS, B2B, mainframe, M&A integration.

## Integration styles (Hohpe & Woolf) — pick deliberately
| Style | Use | Watch |
|---|---|---|
| File transfer (SFTP, S3/Blob drops, AWS Transfer Family) | Batch, partners, legacy | Latency, partial files, idempotent processing |
| Shared database | Avoid between domains | Tight coupling |
| Remote procedure (REST/gRPC/SOAP) | Request-response queries | Temporal coupling, cascading failures |
| Messaging / events | Decoupled state propagation | Eventual consistency, schema governance |

## API-led connectivity (three layers)
**System APIs** (wrap systems of record: SAP, core banking, mainframe) → **Process APIs** (orchestrate business
processes across systems) → **Experience APIs / BFFs** (shape for channels). Benefits: reuse, change isolation;
risk: too many layers → latency and cost — collapse layers where reuse is unlikely.

## API management & governance
- Gateways: AWS API Gateway, Azure API Management, Apigee, Kong, MuleSoft Anypoint; developer portal; product/
  plan/subscription keys; OAuth2 scopes; quotas; analytics; monetization.
- Design-first with **OpenAPI 3.1** (sync) and **AsyncAPI 3** (events); lint with Spectral; style guide
  (naming, errors RFC 9457, pagination, versioning); contract testing (Pact); API catalog & lifecycle
  (design → publish → deprecate → retire); OWASP API Top 10 checks in CI.
- Inventory every API (API9:2023 improper inventory) — shadow/zombie API discovery.

## Event-driven enterprise
- Event types: domain events (facts), integration events (published contract), commands.
- Backbone: Kafka (MSK/Confluent/Event Hubs), EventBridge/Event Grid for routing, **event mesh** (Solace)
  for multi-site/hybrid.
- Standards: **CloudEvents** envelope, schema registry with compatibility rules, event catalog (EventCatalog,
  Backstage), ownership per event, PII classification in schemas.
- Patterns: outbox + CDC, event-carried state transfer, claim check, idempotent consumers, DLQs and replay.

## iPaaS & low-code
MuleSoft, Boomi, Workato, Azure Logic Apps, SAP Integration Suite, Informatica; good for SaaS-to-SaaS and
enterprise app connectors; govern with naming, environments, CI/CD, secrets, and monitoring like code.

## Packaged-app integration
- **SAP**: S/4HANA APIs (OData, SOAP), IDocs, BAPIs/RFC, events via SAP Event Mesh/Advanced Event Mesh; "clean
  core" principle — extend side-by-side (SAP BTP or cloud) rather than modifying core.
- **Salesforce**: REST/Bulk/Streaming APIs, Platform Events, Change Data Capture; API limits.
- **Mainframe**: CICS/IMS via z/OS Connect APIs, MQ, CDC (Precisely, IBM IIDR), file offload; modernization with
  AWS Transform / Azure mainframe migration partners; strangler pattern.

## B2B
EDI (X12, EDIFACT) over AS2/SFTP/VAN, partner onboarding, AWS B2B Data Interchange, Azure Logic Apps
Integration Account; APIs replacing EDI gradually. India-specific rails: UPI, Account Aggregator (ReBIT
specs), ONDC, GSTN/e-invoicing (IRP), DigiLocker.

## Integration for M&A
Identity federation first (day-1), email/collab coexistence, API façades over acquired systems, data
integration via CDC to a shared lakehouse, rationalize later via capability map (see
`enterprise/enterprise-architecture-practice.md`).

## Anti-patterns
ESB with business logic (smart pipes); point-to-point spaghetti; synchronous chains across 5+ systems;
undocumented events; shared canonical model for the whole enterprise (prefer bounded-context contracts with
anti-corruption layers).

## Interview angles
"Integrate core banking, CRM, mobile app, partners and analytics" → system APIs over core, events for state
changes via CDC/outbox, process APIs for onboarding/loans, BFFs per channel, API gateway + OAuth, schema
registry, observability with correlation IDs, DR for the integration layer.
