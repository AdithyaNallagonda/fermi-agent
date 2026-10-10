# Enterprise Data Governance, MDM & Data Products
Last reviewed: 2026-10 | Load when: data strategy, governance programs, MDM, data mesh, AI data readiness.

## DAMA-DMBOK knowledge areas (DMBOK2; DMBOK3 in development ⚠️)
Data Governance (center) · Data Architecture · Data Modeling & Design · Data Storage & Operations · Data
Security · Data Integration & Interoperability · Document & Content Management · Reference & Master Data ·
Data Warehousing & BI · Metadata Management · Data Quality.

## Operating model
- Roles: Chief Data Officer, data governance council, **data owners** (business accountability), **data
  stewards** (definitions, quality), data custodians (technical), domain data product owners.
- Policies: classification (Public/Internal/Confidential/Restricted + PII/SPI tags), retention & deletion,
  access (purpose-based), quality thresholds, lineage requirements, AI/data usage policy.
- Federated computational governance (data mesh): global policies enforced automatically by the platform;
  domains own their data products.

## Data products & contracts
A data product has: owner, SLA/SLOs (freshness, completeness), schema & semantics, quality checks, access
policy, lineage, documentation, discoverability in a catalog. **Data contracts** (e.g., Open Data Contract
Standard / ODCS) formalize producer–consumer agreements; enforce in CI (schema compatibility) and at runtime
(quality gates).

## Master Data Management (MDM) styles
| Style | How | When |
|---|---|---|
| Registry | Index/cross-reference IDs; data stays in sources | Fast, low-intrusion; read-only golden view |
| Consolidation | Copy to hub, match/merge golden record for analytics | Analytics/BI 360 views |
| Coexistence | Hub + sources both author; sync back | Gradual centralization |
| Centralized / transactional | Hub is the system of entry | Strong governance, high change effort |
Key tech: matching & survivorship rules, entity resolution (incl. ML/LLM-assisted), reference data management.
Tools: Informatica, Reltio, Stibo, Profisee, Semarchy; cloud: AWS Entity Resolution, Purview/Fabric, Dataplex.

## Data quality dimensions
Accuracy · completeness · consistency · timeliness/freshness · validity · uniqueness. Measure per critical data
element; monitor with Glue Data Quality / Great Expectations / Soda / dbt tests / data observability tools
(Monte Carlo, etc.).

## Metadata, catalog & lineage
Technical + business + operational metadata; business glossary; lineage via OpenLineage (Airflow, Spark, dbt);
catalogs: Unity Catalog, AWS Glue Data Catalog + SageMaker Catalog/DataZone, Microsoft Purview, Google Dataplex,
Collibra, Alation, Atlan, DataHub, OpenMetadata.

## Privacy engineering
Data minimization, purpose limitation, consent tracking (India DPDP: consent managers from Nov 2026), PII
discovery (Macie, Purview, Sensitive Data Protection), masking/tokenization/format-preserving encryption,
pseudonymization for analytics, right-to-erasure workflows across lake + warehouse + backups + vector stores,
cross-border transfer controls. See `enterprise/regulatory-architecture.md`.

## AI data readiness
Inventory of unstructured content with owners and ACLs; document-level permissions preserved into RAG indexes;
quality and freshness SLAs for knowledge sources; lineage from source document → chunk → answer citation;
training-data provenance and licensing; evaluation datasets governed like code.

## Interview angles
"Launch a data governance program in a bank" → start with critical data elements tied to regulatory reports and
top use cases; assign owners/stewards; catalog + lineage; quality SLAs; automate policies in the platform;
measure issue resolution time and report accuracy.
