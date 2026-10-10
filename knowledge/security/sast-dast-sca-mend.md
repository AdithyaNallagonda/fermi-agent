# Application Security Testing: SAST, DAST, SCA (Mend), Secrets, IaC, Containers
Last reviewed: 2026-10 ⚠️ vendor product names/features change; verify

## Testing types
| Type | What | When | Strengths | Limits |
|---|---|---|---|---|
| SAST | Analyzes source/bytecode for vulnerable patterns (taint: source → sink) | IDE, PR, CI | Early, pinpoints code line | False positives, no runtime context |
| SCA | Identifies open-source components & known CVEs, licenses, malicious packages | PR, CI, continuous monitoring | Huge coverage (most code is OSS) | Reachability needed to prioritize |
| Secrets scanning | Hard-coded credentials | Pre-commit, PR, history | Prevents leaks | Needs rotation on hit |
| IaC scanning | Misconfigurations in Terraform/CFN/K8s/Bicep | PR | Cheap prevention | Policy tuning |
| Container scanning | OS packages & libs in images, Dockerfile issues | Build, registry, runtime | Covers base images | Noise from unfixable CVEs |
| DAST | Black-box testing of running app (HTTP) | Staging/nightly | Real exploitability, config issues | Slower, coverage depends on crawling/auth |
| IAST | Instrumented runtime analysis during tests | QA | Low false positives | Language/agent support |
| API security testing | Schema-driven fuzzing, BOLA tests | Staging | API-specific flaws | Needs OpenAPI specs |
| Pentest | Human-led | Major releases/annual | Business logic flaws | Point-in-time |

## Tools landscape
- SAST: CodeQL (GitHub Advanced Security), Semgrep, SonarQube/SonarCloud, Checkmarx, Veracode, Fortify,
  Snyk Code, **Mend SAST**, language analyzers (Roslyn, Bandit, ESLint security plugins, SpotBugs).
- SCA: **Mend SCA** (formerly WhiteSource), Snyk Open Source, Black Duck, Dependabot, OWASP
  Dependency-Check/Dependency-Track, JFrog Xray, GitHub Dependabot alerts.
- Secrets: Gitleaks, TruffleHog, GitHub secret scanning + push protection, GitGuardian.
- IaC: Checkov, Trivy (config), KICS, tfsec (merged into Trivy), Terrascan.
- Containers: Trivy, Grype, Amazon Inspector, Defender for Containers, Prisma Cloud, Mend container.
- DAST: OWASP ZAP (ZAP by Checkmarx ⚠️), Burp Suite Enterprise/DAST, Invicti, StackHawk, Rapid7.

## Mend (Mend.io) specifics
- Products: **Mend SCA** (open-source risk & license compliance, reachability analysis to prioritize
  called vulnerable functions), **Mend SAST**, **Mend Container**, **Mend Renovate** (automated dependency
  update PRs), **Mend AI** (AI component inventory/AI-BOM, model risks ⚠️).
- Integration: **Mend CLI** (`mend dep`, `mend code`, `mend image` ⚠️ verify commands) in pipelines;
  legacy Unified Agent; repo integrations (GitHub/GitLab/Bitbucket/Azure Repos apps) that scan on push
  and open issues/PR checks; IDE plugins.
- Policies: block/reassign by CVSS/EPSS severity, license type (e.g., deny AGPL in distributed
  software), malicious package detection; effective usage/reachability to cut noise.
- Outputs: SBOM (SPDX/CycloneDX), due-diligence/license reports, risk dashboards.
- Practice: run on PR with "new issues only" gating; nightly full scans; Renovate with auto-merge for
  patch updates that pass tests; triage SLAs per severity.

## Prioritization signals
CVSS (severity) + **EPSS** (probability of exploitation) + **CISA KEV** (known exploited) + reachability +
asset criticality + internet exposure. Fix KEV + reachable criticals first.

## Triage workflow
1. Validate (true/false positive; reachable?). 2. Contextual severity. 3. Fix (upgrade/patch/code change/
config) with regression test. 4. If no fix: mitigate (WAF rule, disable feature) + documented exception.
5. Verify closure on rescan.

## Pipeline example (GitHub Actions, conceptual)
```yaml
jobs:
  security:
    steps:
      - uses: actions/checkout@<sha>
      - run: gitleaks detect --redact
      - run: semgrep ci                      # SAST
      - run: mend dep --scan . --fail-policy # SCA (verify CLI flags)
      - run: checkov -d infra/              # IaC
      - run: trivy image --exit-code 1 --severity CRITICAL,HIGH $IMAGE
```

## Interview angles
SAST vs DAST vs SCA vs IAST; how to reduce false positives and developer friction (diff-aware gating,
reachability, IDE feedback, champions); handling Log4Shell-type zero-days (SBOM search → exposure →
patch/mitigate → verify).
