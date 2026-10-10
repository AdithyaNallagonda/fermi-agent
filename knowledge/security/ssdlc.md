# Secure Software Development Lifecycle (SSDLC)
Last reviewed: 2026-10 | Frameworks: NIST SSDF (SP 800-218), OWASP SAMM, BSIMM, Microsoft SDL

## Activities by phase
| Phase | Activities | Artifacts / tools |
|---|---|---|
| Training & culture | Secure coding training by stack, security champions (1 per team), gamified labs | Champion charter |
| Requirements | Security & privacy requirements (ASVS level), abuse cases, data classification, compliance mapping | Security requirements in backlog |
| Design | Threat modeling (STRIDE/PASTA/LINDDUN), security architecture review, crypto choices, authN/authZ design | Threat model, ADRs |
| Implementation | Secure coding standards, pre-commit hooks (secrets), IDE plugins (SAST/SCA), peer review checklist | Linters, Semgrep/CodeQL, Mend IDE |
| Build / CI | SAST, SCA + license compliance, secrets scanning, IaC scanning, container scanning, SBOM generation | Gates per severity |
| Test | DAST (authenticated), API security testing, fuzzing, pentest for major releases, security unit tests | ZAP/Burp, pentest reports |
| Release | Security sign-off criteria, signed artifacts, change approval, exception register | Release checklist |
| Deploy & operate | WAF, RASP (optional), CSPM, runtime detection, secrets rotation, patching SLAs | SIEM, CSPM |
| Respond | Vulnerability disclosure program/bug bounty, incident response, root-cause fixes, lessons learned | IR runbooks |

## Quality gates & SLAs (example policy)
| Severity | Gate | Remediation SLA (prod) |
|---|---|---|
| Critical | Block merge/release | 7 days (24–72 h if exploited in the wild / CISA KEV) |
| High | Block release (exception needs CISO delegate approval) | 30 days |
| Medium | Warn | 90 days |
| Low | Track | Best effort |
Gate on **new** findings in PRs (diff-aware) to avoid blocking on legacy debt; burn down legacy separately.

## Exception management
Documented risk acceptance with justification, compensating controls, owner, expiry date (≤ 90 days),
periodic review.

## Metrics
% repos onboarded to each scanner; mean time to remediate by severity; SLA compliance %; vulnerability
escape rate (found in prod vs pre-prod); open criticals trend; false-positive rate (tool tuning);
training completion; threat models per new feature.

## Rollout plan for an enterprise (90 days)
1. Days 0–30: inventory apps/repos, choose toolchain, pilot 3–5 teams, define policy & SLAs.
2. Days 31–60: onboard via pipeline templates (golden paths), champions program, dashboards.
3. Days 61–90: enforce gates for new code, exception workflow, executive reporting, expand coverage.

## Compliance mapping
PCI DSS 4.0 (Req. 6 secure development), SOC 2 (CC8 change management), ISO 27001:2022 (A.8.25–A.8.29
secure development), NIST SSDF, EO 14028 / CISA secure software attestation, RBI/SEBI guidelines (India
BFSI), DPDP Act 2023 (privacy by design).
