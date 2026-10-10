# Playbook: AI / LLM Solution Design

Knowledge: `knowledge/ai/*`, `knowledge/security/ai-security.md`, cloud AI platform file.
Verify current model names, prices, context windows, and regional availability live — they change monthly.

## Step 1 — Is AI the right tool?
Define the task (classify, extract, summarize, generate, converse, act). Could rules/search/classic ML
solve it cheaper and more reliably? Define success metrics and an **evaluation set first** (50–200
labeled examples).

## Step 2 — Pick the pattern (cheapest that works)
Prompting → prompting + few-shot → RAG → tool use / agents → fine-tuning (style/format/latency/cost) →
pre-training (almost never). Combine: RAG for knowledge, fine-tuning for behavior.

## Step 3 — Architecture
- Model access: managed API (Bedrock/AgentCore, Microsoft Foundry, Gemini Enterprise Agent Platform (ex-Vertex AI), Anthropic API) vs self-hosted
  (vLLM/TGI/SGLang on GPUs, SageMaker, AKS/GKE). Decide on data residency, cost at volume, latency.
- RAG pipeline: ingestion → parsing → chunking → embedding → vector store → retrieval (hybrid +
  rerank) → prompt assembly → generation → citation → guardrails. See `knowledge/ai/rag-architecture.md`.
- Agents: tool contracts, MCP servers, planning loop, memory, state, human-in-the-loop, budgets.
- Gateway: AI gateway for routing, rate limiting, caching (exact + semantic), cost attribution, fallback.

## Step 4 — Non-functionals for AI
Latency (TTFT, tokens/s, streaming), cost per request (input/output tokens, caching), throughput
(TPM/RPM quotas, provisioned throughput), quality (eval scores), safety (guardrails, red teaming),
privacy (PII redaction, no-training data terms), observability (traces of prompts/tool calls,
token usage, feedback).

## Step 5 — Security
OWASP LLM Top 10 2025 controls: input/output filtering, prompt-injection defenses (separate
instructions from data, least-privilege tools, confirm destructive actions), RAG access control at
retrieval time (document-level ACLs), secrets never in prompts, rate limits against unbounded
consumption.

## Step 6 — LLMOps
Prompt/version management, offline evals in CI, online evals + user feedback, regression gates,
model upgrade playbook, drift monitoring. See `knowledge/ai/mlops-and-llmops.md`.

## Step 7 — Cost model
Tokens/request × requests/day × price; show savings from prompt caching, smaller-model routing,
batch APIs, and retrieval trimming.

## Final step — Adversarial audit (mandatory)
Follow `instructions/adversarial-audit.md` as the senior reviewer of this work. Tier: **Standard (Deep for regulated/customer-facing AI)**.
Apply: B (pattern/model/platform choice; lifecycle — no maintenance/deprecated services), E (model names, prices, regional availability verified), R-check token-cost math, D (prompts/code/evals produced). Fix Blockers before presenting; end with the 🔍 audit summary
(`principles/adversarial-self-audit.md`).
