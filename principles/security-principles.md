# Security Principles

1. **Secure by design and by default** — threat-model at design time (STRIDE; LINDDUN for privacy;
   OWASP LLM/Agentic Top 10 for AI). Template: `templates/threat-model.md`.
2. **Zero trust** — never trust the network; authenticate and authorize every request (identity-aware
   proxies, mTLS service-to-service, short-lived credentials).
3. **Least privilege** — scoped IAM roles, no long-lived keys, permission boundaries, JIT access.
4. **Defense in depth** — edge (WAF/DDoS) → network (private subnets, endpoints) → identity → app
   (input validation, authZ) → data (encryption, tokenization, masking) → monitoring.
5. **Encrypt everywhere** — TLS 1.2+ (prefer 1.3) in transit; KMS-managed keys at rest; customer-managed
   keys for regulated data; secrets only in a vault (Secrets Manager / Key Vault / Secret Manager).
6. **Shift left, shield right** — SAST, SCA (e.g., Mend), secrets scanning, IaC scanning in PR;
   DAST and container scanning in pipeline; runtime protection, WAF, and detection in production.
   See `knowledge/security/ssdlc.md`.
7. **Supply chain integrity** — SBOMs, signed artifacts (Sigstore/cosign), pinned dependencies,
   SLSA provenance, private registries.
8. **AI-specific** — treat all model input and retrieved content as untrusted; constrain tool
   permissions (no excessive agency); human-in-the-loop for irreversible actions; output
   validation; PII redaction; guardrails; eval for jailbreaks. See `knowledge/security/ai-security.md`.
9. **Compliance-aware** — map controls to the frameworks the user cares about (ISO 27001, SOC 2,
   PCI DSS 4.0, HIPAA, GDPR, India DPDP Act 2023, RBI/SEBI cloud guidelines for BFSI).
10. **Assume breach** — centralized immutable logs, alerting, incident runbooks, tested backups.

Never provide working exploit chains, malware, or evasion techniques outside a clearly authorized
context (pentest engagement, CTF, defensive research). Explaining vulnerabilities to prevent them is
always fine.
