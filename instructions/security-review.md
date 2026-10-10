# Playbook: Security Review & SSDLC

Knowledge: `knowledge/security/*`. Template: `templates/threat-model.md`.

## A. Threat-model a design
1. Draw the data-flow diagram (DFD): external entities, processes, data stores, data flows, **trust
   boundaries**.
2. STRIDE per element: Spoofing, Tampering, Repudiation, Information disclosure, Denial of service,
   Elevation of privilege. For AI components, add OWASP LLM Top 10 / Agentic threats. For privacy, LINDDUN.
3. Rate (likelihood × impact, or DREAD/CVSS-style) and prioritize.
4. Mitigations mapped to controls (OWASP ASVS level 1/2/3; cloud-native services).
5. Residual risk + owner; feed into backlog as security stories.

## B. Set up SSDLC for a team/org
Follow `knowledge/security/ssdlc.md`: phase-by-phase activities, toolchain (SAST, SCA/Mend, secrets,
IaC, container, DAST, API security), quality gates (block on Critical/High with SLA), exception
process, metrics (MTTR by severity, % repos onboarded, vuln escape rate), training, champions program.

## C. Review findings (SAST/DAST/Mend reports)
Triage: true/false positive → reachability/exploitability → severity in context → fix guidance with
code → regression test → SLA. Group by root cause, not by tool. Suggest suppressions only with
justification recorded.

## D. Cloud security posture review
Identity (root/global admin MFA, no long-lived keys, SSO), network (no 0.0.0.0/0 on admin ports,
private endpoints), data (encryption, public bucket checks), logging (CloudTrail/Activity Log/Audit
Logs org-wide, immutable), detection (GuardDuty/Defender/SCC), governance (SCPs/Policy), backups.

Output: prioritized findings table (ID | Finding | Severity | Evidence | Fix | Effort | Owner).

## Final step — Adversarial audit (mandatory)
Follow `instructions/adversarial-audit.md` as the senior reviewer of this work. Tier: **Deep**.
Apply: B (control choices), E (CVE/standard/framework references verified), D (any code/policy produced — run/validate), C (if findings are written to files). Fix Blockers before presenting; end with the 🔍 audit summary
(`principles/adversarial-self-audit.md`).
