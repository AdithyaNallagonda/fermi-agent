# Regulatory Architecture (India focus + global)
Last reviewed: 2026-10 ⚠️ Regulations change — verify with official sources and always involve legal/compliance.
Load when: designing for BFSI/healthcare/government/AI regulation, data residency, privacy, audits.
This file is architectural guidance, not legal advice.

## India
| Regulation | Architecture-relevant requirements |
|---|---|
| **DPDP Act 2023 + DPDP Rules 2025** (Rules notified 14 Nov 2025) | Phased: **immediate** (Data Protection Board, definitions); **14 Nov 2026** consent managers register; **14 May 2027** substantive obligations — notices & consent, security safeguards, breach notification (to DPB and affected principals; detailed report within 72 h), children's data (verifiable parental consent), Significant Data Fiduciary duties (DPIA, audits, possible localisation of specified data). Penalties up to ₹250 crore per breach category. Design: consent ledger, purpose tags, erasure workflows, breach detection/response, data inventories |
| **CERT-In Directions (Apr 2022)** | Report specified incidents within **6 hours**; retain ICT system logs **180 days within India**; sync clocks to NIC/NPL NTP; cloud/VPN/data-centre providers retain subscriber records (5 years) |
| **RBI** | Payment system data stored **only in India** (2018 circular); Master Direction on **Outsourcing of IT Services** (2023): cloud allowed with risk assessment, audit/access rights for RBI, exit strategy, data in India for specified data; Master Direction on **IT Governance, Risk, Controls & Assurance** (2023); cyber-resilience and DR drills; IFS Cloud (IFTAS) as a sector cloud option ⚠️ |
| **SEBI** | Framework for Adoption of Cloud Services (2023): data localisation, regulator access, exit plans; **CSCRF** (Cybersecurity & Cyber Resilience Framework, Aug 2024; most deadlines passed by Aug 2025 — now recurring audits/reporting) |
| **IRDAI** | Information & Cyber Security Guidelines; data localisation for policyholder data ⚠️ |
| Sector/gov | MeitY empanelled cloud (GCC / government community cloud), GIGW for gov websites, ABDM for health data |

## Global
| Regulation | Key points |
|---|---|
| **EU AI Act** | In force Aug 2024; prohibited practices Feb 2025; GPAI obligations Aug 2025 (unchanged). **Digital Omnibus agreement (7 May 2026)** postpones high-risk obligations: Annex III standalone systems → **2 Dec 2027**; Annex I product-embedded → **2 Aug 2028** ⚠️ verify formal adoption |
| GDPR | Lawful basis, DPIAs, data subject rights, SCCs for transfers, 72-hour breach notification |
| PCI DSS v4.0.1 | Future-dated requirements mandatory since 31 Mar 2025 (e.g., script integrity on payment pages, authenticated internal scans, MFA for all CDE access) |
| HIPAA / SOC 2 / ISO 27001:2022 / ISO 42001 | Control frameworks to map architecture to |
| DORA (EU financial) | ICT risk, incident reporting, third-party (cloud) risk, resilience testing — applies to EU entities served from Indian GCCs |

## Architecture patterns for compliance
1. **Residency by policy**: region allow-lists (SCP/Azure Policy/Org Policy), India regions (AWS ap-south-1/2,
   Azure Central/South/West India, GCP asia-south1/2); disable global/cross-Region AI inference where data must
   stay in India.
2. **Key sovereignty**: customer-managed keys, HSM, external key stores (AWS XKS, Azure Managed HSM, GCP EKM) for
   hold-your-own-key requirements.
3. **Evidence automation**: config rules/policies mapped to control IDs; automated audit packs (AWS Audit Manager
   is in maintenance → use Security Hub/Config conformance packs or GRC tools); immutable logs.
4. **Privacy by design**: data inventory + classification at ingestion, consent & purpose propagated as metadata,
   erasure across all copies (incl. backups policy & vector indexes).
5. **Regulator access & exit**: documented access paths for auditors, data export runbooks, multi-vendor exit plan.
6. **AI governance**: risk-tier use cases, model cards, human oversight, logging of decisions, evals for bias &
   safety; map to EU AI Act / NIST AI RMF / ISO 42001.

## Interview angles
"Design a lending platform for an Indian NBFC" → data in India, RBI outsourcing controls, CERT-In logging, DPDP
consent + erasure, KMS/HSM, DR region within India (Mumbai ↔ Hyderabad), audit evidence automation, AI credit
models with explainability and human review.
