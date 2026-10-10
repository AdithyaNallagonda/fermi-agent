# OWASP Standards
Last reviewed: 2026-10 (Top 10:2025 verified at top10.owasp.org/2025 — announced Nov 2025 at Global AppSec DC,
final release Jan 2026). Use 2025 as the default reference; keep 2021 mapping for older audits/questionnaires.

## OWASP Top 10 (Web)
| # | 2021 | 2025 |
|---|---|---|
| A01 | Broken Access Control | Broken Access Control |
| A02 | Cryptographic Failures | Security Misconfiguration |
| A03 | Injection | Software Supply Chain Failures |
| A04 | Insecure Design | Cryptographic Failures |
| A05 | Security Misconfiguration | Injection |
| A06 | Vulnerable & Outdated Components | Insecure Design |
| A07 | Identification & Authentication Failures | Authentication Failures |
| A08 | Software & Data Integrity Failures | Software or Data Integrity Failures |
| A09 | Security Logging & Monitoring Failures | Security Logging & Alerting Failures |
| A10 | SSRF | Mishandling of Exceptional Conditions (SSRF merged into A01) |

### Key mitigations
- Access control: deny by default, server-side checks on every request, object-level ownership checks,
  policy engines (OPA, Cedar/Verified Permissions), no IDOR.
- Misconfiguration: hardened baselines, IaC scanning, no default creds, minimal features, security headers.
- Supply chain: SBOM, SCA, signed artifacts, pinned deps, trusted registries, SLSA.
- Crypto: TLS 1.2+, AES-GCM, Argon2id/bcrypt for passwords, KMS-managed keys, no homegrown crypto.
- Injection: parameterized queries, ORM, output encoding, input validation (allowlist), safe APIs.
- Insecure design: threat modeling, secure design patterns, rate limits on business flows.
- AuthN: MFA, phishing-resistant (passkeys/FIDO2), session management, credential stuffing protection.
- Integrity: verify signatures of updates/CI artifacts, safe deserialization.
- Logging: security events logged with context, centralized, alerting, tamper-resistant.
- Exceptional conditions: fail closed, consistent error handling, no stack traces to users.
- SSRF: allowlist outbound destinations, block metadata endpoints (IMDSv2), network egress controls.

## OWASP API Security Top 10 (2023)
API1 Broken Object Level Authorization (BOLA) · API2 Broken Authentication · API3 Broken Object Property
Level Authorization (mass assignment/excessive data exposure) · API4 Unrestricted Resource Consumption ·
API5 Broken Function Level Authorization · API6 Unrestricted Access to Sensitive Business Flows · API7
SSRF · API8 Security Misconfiguration · API9 Improper Inventory Management · API10 Unsafe Consumption of
APIs.

## OWASP Top 10 for LLM Applications (2025)
LLM01 Prompt Injection · LLM02 Sensitive Information Disclosure · LLM03 Supply Chain · LLM04 Data and
Model Poisoning · LLM05 Improper Output Handling · LLM06 Excessive Agency · LLM07 System Prompt Leakage ·
LLM08 Vector and Embedding Weaknesses · LLM09 Misinformation · LLM10 Unbounded Consumption.
(Also: OWASP Top 10 for Agentic Applications (2026 edition, released Dec 2025) ⚠️ — see `ai-security.md`.)

## Other OWASP resources
- **ASVS** (Application Security Verification Standard, v5.0 released 2025): L1 (basic), L2 (most apps),
  L3 (high assurance). Use as security requirements/test checklist.
- **SAMM** (Software Assurance Maturity Model): Governance, Design, Implementation, Verification,
  Operations — maturity levels 1–3; use to assess/plan an AppSec program.
- **Cheat Sheet Series**: practical guidance per topic.
- **MASVS/MASTG**: mobile security.
- **WSTG**: web security testing guide.
- **CycloneDX** (SBOM standard), **Dependency-Track**, **ZAP** (DAST, now under Checkmarx sponsorship ⚠️).

## Interview angles
Explain BOLA with an example and fix; difference between authN and authZ failures; how to embed ASVS into
user stories; SSRF in cloud (metadata service) and mitigations (IMDSv2, egress filtering).
