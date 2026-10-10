# Google Cloud Certifications
Last reviewed: 2026-10 ⚠️ verify at cloud.google.com/learn/certification

## Portfolio
| Level | Certification |
|---|---|
| Foundational | Cloud Digital Leader · Generative AI Leader |
| Associate | Associate Cloud Engineer (ACE) · Associate Data Practitioner · Associate Google Workspace Administrator |
| Professional | **Professional Cloud Architect (PCA)** · Cloud Developer · Data Engineer · Cloud DevOps Engineer · Cloud Security Engineer · Cloud Network Engineer · Machine Learning Engineer · Cloud Database Engineer · Security Operations Engineer |

## PCA (refreshed October 2025)
- ~50–60 questions, 2 hours; case studies = ~20–30% of questions.
- **Current case studies**: **EHR Healthcare** (retained), **Altostrat Media**, **Cymbal Retail**,
  **KnightMotives Automotive** (replaced Helicopter Racing League, Mountkirk Games, TerramEarth). All now embed
  **AI integration as a core business requirement** → expect Vertex AI / Gemini Enterprise Agent Platform, RAG,
  BigQuery ML, streaming + IoT/edge, personalization questions.
- Validity 2 years; existing certs valid until normal expiry.
- Platform naming changed in 2026: **Vertex AI → Gemini Enterprise Agent Platform** (Agent Engine, ADK, Agent
  Studio, Model Garden). Exams may use either name during transition ⚠️.

## Case-study prep method
For each case: extract business requirements → technical requirements → constraints → map to services → identify
the 2–3 trade-offs an examiner would test (e.g., Altostrat: media pipelines + content AI at scale; Cymbal Retail:
real-time personalization, inventory ML, BigQuery; KnightMotives: IoT ingestion, edge, data residency; EHR:
hybrid connectivity, HIPAA-like compliance, migration).

## KB mapping
`cloud/gcp.md`, `networking/gcp-networking.md`, `databases/newsql-distributed-sql.md` (Spanner),
`databases/cassandra-and-wide-column.md` (Bigtable), `databases/cloud-data-warehouses.md` (BigQuery),
`ai/cloud-ai-platforms.md`.

## Study approach & technique
Google Cloud Skills Boost paths & labs, official sample questions, Architecture Center, Well-Architected
Framework (Google Cloud), $300 new-account credit. Prefer Google-recommended managed services; know DB/compute/LB
decision trees; IAM best practices (groups, least privilege, WIF, no SA keys); VPC Service Controls for
exfiltration; cost → CUDs, Spot, BigQuery partitioning/clustering/editions.
