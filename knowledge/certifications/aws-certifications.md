# AWS Certifications
Last reviewed: 2026-10 (verified against aws.amazon.com/certification pages on 2026-10-10)
⚠️ AWS is mid-refresh: re-verify codes/dates before building any study plan.

## Current portfolio (verified 2026-10-10)
| Category | Certification | Exam code | Status / key dates |
|---|---|---|---|
| Business (new) | AI Business Strategist | AIB-C01 | **Beta**: registration opened 1 Sep 2026, delivery from 29 Sep 2026; early-adopter badge if earned by 15 Feb 2027. No AWS/coding experience required |
| Foundational | Cloud Practitioner | CLF-C02 | Current |
| Foundational | AI Practitioner | AIF-C01 | Current |
| Associate | Solutions Architect – Associate | SAA-C03 | Current (65 Q, 130 min, $150). **No new version announced** (ignore blog claims of "SAA-C04") |
| Associate | Developer – Associate | DVA-C02 → **DVA-C03** | DVA-C03 registration opens **27 Oct 2026**; last day for DVA-C02 **30 Nov 2026** |
| Associate | CloudOps Engineer – Associate (renamed from SysOps Administrator) | SOA-C03 | Current |
| Associate | Data Engineer – Associate | DEA-C01 | Current |
| Associate | Machine Learning Engineer – Associate | MLA-C01 → **MLA-C02** | MLA-C02 beta from 1 Sep 2026 (85 Q, 170 min, adds GenAI/Bedrock/RAG/agentic AI); MLA-C01 English last day **28 Sep 2026** |
| Professional | Solutions Architect – Professional | SAP-C02 → **SAP-C03** | SAP-C03 registration opens **27 Oct 2026**; last day for SAP-C02 **16 Nov 2026** (75 Q, 180 min, $300) |
| Professional | DevOps Engineer – Professional | DOP-C02 | Current |
| Professional | Generative AI Developer – Professional | AIP-C01 | GA after beta (closed 31 Mar 2026); 75 Q, 180 min, $300; Bedrock, AgentCore, RAG, guardrails, evaluation |
| Specialty | Security – Specialty | SCS-C03 | Current since 2 Dec 2025 (65 Q, 170 min); adds a GenAI/ML security domain; detection & IR merged |
| Specialty | Advanced Networking – Specialty | ANS-C01 | **Retiring: last day 31 Dec 2026**; existing certs stay valid 3 years |
| Retired | Machine Learning – Specialty | MLS-C01 | Retired 31 Mar 2026 → use MLA + AIP |
| Retired (2024) | Data Analytics Specialty, Database Specialty, SAP on AWS Specialty | — | Retired |

Also new: **AWS microcredentials** — hands-on, live-environment assessments (serverless, agentic AI, application
networking, incident response) that complement certs; **"AWS Serverless Demonstrated"** style credentials.

## Recommended SA path (2026–27)
1. **SAA-C03** (6–8 weeks).
2. **SAP**: if exam date is before 16 Nov 2026 → SAP-C02 with existing materials; otherwise wait for the SAP-C03
   exam guide (27 Oct 2026) and map it to this KB before studying. Don't buy C02-only prep after October.
3. Specialization: **SCS-C03** (security architects), **AIP-C01** (GenAI architects — high market demand),
   **DEA-C01** (data architects). ANS-C01 only if you can sit it before 31 Dec 2026 — otherwise build networking
   depth via `networking/aws-networking.md` + microcredentials.
4. Business/presales SAs: AIB-C01 is cheap signal for AI value conversations (not a technical substitute).

## SAA-C03 domains
Design Secure Architectures (30%) · Design Resilient Architectures (26%) · Design High-Performing Architectures
(24%) · Design Cost-Optimized Architectures (20%).
KB map: `cloud/aws.md`, `networking/aws-networking.md`, `databases/dynamodb.md`, `databases/postgresql.md`,
`fundamentals/reliability-and-resilience.md`, `security/identity-and-access.md`, `cloud/well-architected-and-finops.md`.

## SAP-C02 domains (C03 may change — verify)
Design Solutions for Organizational Complexity (26%) · Design for New Solutions (29%) · Continuous Improvement for
Existing Solutions (25%) · Accelerate Workload Migration and Modernization (20%).
Focus: Organizations/SCPs/RCPs/Control Tower, cross-account networking (TGW, Cloud WAN, PrivateLink, RAM, VPC
Lattice), hybrid DNS, DR strategies & ARC, migration (AWS Transform, MGN, DMS), cost at scale, decoupling, data
perimeters. Expect C03 to add GenAI/agentic architecture (Bedrock, AgentCore) and remove services in maintenance.

## AIP-C01 focus areas
Bedrock model selection & invocation (Converse, prompt caching, cross-Region inference), Knowledge Bases & vector
stores (OpenSearch Serverless, Aurora pgvector, S3 Vectors), AgentCore (Runtime, Gateway, Identity, Memory, Policy,
harness), Guardrails, evaluation, LLMOps, cost & security. KB: `ai/*`, `security/ai-security.md`.

## Legitimate resources
AWS Skill Builder 4-step exam prep plans (official practice question sets, pretests, official practice exams,
Builder Labs, SimuLearn, Cloud Quest, Jam), exam guides, Well-Architected whitepapers & lenses, AWS docs/FAQs. Reputable
third-party courses/practice tests. Never dumps.

## Exam technique
Keywords decide: "least operational overhead" → managed/serverless; "most cost-effective" → Spot/S3 lifecycle/
Savings Plans; "minimal changes" → lift-and-shift options; "near real-time" → streams; "decouple" → SQS/SNS/
EventBridge. Eliminate insecure, non-HA, or over-engineered answers. Exams now show **short service names** with a
Help-button glossary. Note services moved to maintenance (App Runner, Q Business, Kendra, Bedrock Agents Classic,
etc. — see `cloud/aws.md`) are unlikely as "correct" answers on refreshed exams.

## Logistics
Pearson VUE (test center or online proctored); 50% voucher for the next exam after passing; 3-year validity;
recertify by passing the latest version or a higher-level exam (SAP recertifies SAA); new Skill Builder-based
maintenance option announced ⚠️ verify details.
