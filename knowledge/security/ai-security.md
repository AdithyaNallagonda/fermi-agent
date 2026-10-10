# AI / LLM Security
Last reviewed: 2026-10 ⚠️ fast-moving field

## Threat landscape
| Threat | Description | Controls |
|---|---|---|
| Direct prompt injection / jailbreak | User manipulates model to ignore instructions | System prompt hardening (not sufficient alone), input classifiers, guardrails, output checks, least-privilege tools |
| Indirect prompt injection | Malicious instructions inside retrieved docs, web pages, emails, tool outputs | Treat retrieved content as data; segregate/tag untrusted content; restrict tools after reading untrusted content; human confirmation for side effects |
| Sensitive data disclosure | PII/secrets in prompts, training data, outputs | PII redaction (Presidio, Comprehend, guardrails), data classification, no secrets in prompts, output filters |
| Excessive agency | Agent takes harmful actions with broad permissions | Scoped tools, allowlisted actions, per-user delegated auth (OAuth on-behalf-of), budgets, HITL approvals, dry-run modes |
| Insecure output handling | LLM output executed/rendered unsafely (XSS, SQLi, command injection) | Treat output as untrusted: encode, validate against schema, sandbox code execution |
| RAG/vector weaknesses | Cross-tenant leakage, poisoning of knowledge base, embedding inversion | Document-level ACL filtering at retrieval, tenant isolation (separate indexes/namespaces), ingestion validation, provenance |
| Data & model poisoning | Training/fine-tuning data manipulated | Dataset provenance, validation, signed models, eval regression |
| Supply chain | Malicious models (pickle), compromised packages, MCP servers | Safetensors, model scanning, trusted registries, pin & verify MCP servers, AI-BOM |
| System prompt leakage | Revealing instructions/secrets | Never put secrets in prompts; assume prompts are public |
| Unbounded consumption | Cost/DoS via huge prompts or loops | Rate limits, token caps, max tool iterations, timeouts, quotas per tenant |
| Misinformation / hallucination | Wrong but confident answers | Grounding with citations, abstain behavior, evals, UX disclaimers |

## Agentic-specific (OWASP Agentic Top 10 / MCP)
Tool poisoning & rug pulls in MCP servers (malicious tool descriptions), confused deputy, memory poisoning,
identity & privilege abuse, cascading failures across agents, unsafe code execution. Controls: verified
MCP servers, tool description review/pinning, OAuth-scoped tokens per user, sandboxed execution
(containers/microVMs), audit trails of every tool call, kill switches.

## Frameworks & standards
- **OWASP Top 10 for LLM Applications 2025**, OWASP GenAI Security Project, Agentic AI threats guidance.
- **MITRE ATLAS** (adversarial tactics/techniques for AI systems).
- **NIST AI RMF 1.0** (Govern, Map, Measure, Manage) + Generative AI Profile (NIST AI 600-1).
- **ISO/IEC 42001** (AI management system), ISO/IEC 23894 (AI risk).
- **EU AI Act** (risk tiers; GPAI obligations from Aug 2025; high-risk obligations phased ⚠️).
- India: MeitY AI governance guidelines ⚠️ verify; DPDP Act applies to personal data in AI.
- Cloud guardrails: Bedrock Guardrails (content filters, denied topics, PII, contextual grounding,
  automated reasoning checks), Azure AI Content Safety (Prompt Shields, groundedness detection),
  Vertex AI safety filters / Model Armor; open-source: NeMo Guardrails, Llama Guard, Guardrails AI.

## Secure AI architecture checklist
- [ ] AI gateway: authN, per-tenant quotas, logging, PII redaction, model allowlist
- [ ] Input guardrails (injection/jailbreak detection, topic restrictions)
- [ ] RAG ACLs enforced at query time with user identity (not just at ingestion)
- [ ] Tools least-privilege; destructive actions need confirmation; no raw shell/SQL tools for end users
- [ ] Output validation (JSON schema), encoding, groundedness check, citations
- [ ] Red-teaming (PyRIT, garak, promptfoo) before launch and in CI
- [ ] Monitoring: prompt/response logs with privacy controls, abuse detection, cost anomalies
- [ ] Data governance: provider no-training terms, residency, retention, encryption
- [ ] Incident response playbook for AI misuse
