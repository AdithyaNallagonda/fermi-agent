# Cloud AI Platforms
Last reviewed: 2026-10 (verified via aws-knowledge MCP, Microsoft Learn MCP, and Google Cloud Next '26 coverage)
⚠️ Model catalogs, regions, and names change monthly — always verify before quoting.

## Amazon Bedrock (AWS)
- **Models**: serverless access to Anthropic Claude, Amazon Nova, Meta Llama, Mistral, Cohere, AI21, DeepSeek,
  OpenAI open-weight, Qwen, etc. (per Region). APIs: **Converse** (unified chat + tools), InvokeModel, streaming;
  **cross-Region inference profiles** (geographic or global — check data-residency implications for India/BFSI),
  batch inference (~50% cheaper), prompt caching, provisioned throughput, latency-optimized and service tiers.
- **Knowledge Bases** (managed RAG): vector stores incl. OpenSearch Serverless, Aurora pgvector, **S3 Vectors**
  (GA Dec 2025), Pinecone, Redis, MongoDB Atlas, Neptune Analytics (GraphRAG); structured retrieval (NL→SQL).
- **Guardrails**: content filters, denied topics, PII, word filters, contextual grounding, **Automated Reasoning
  checks**; apply to any model (ApplyGuardrail API).
- **Bedrock Agents Classic** → **in maintenance (2026)**: build new agents on AgentCore.
- **Amazon Bedrock AgentCore** (GA) — framework- and model-agnostic agent platform:
  | Component | Purpose |
  |---|---|
  | **Runtime** | Serverless agent hosting; each session in an isolated **microVM**; long-running sessions |
  | **Harness** (GA 2026) | Managed agent loop — "idea to production agent in minutes"; auto-provisions memory (semantic + summarization, 30-day expiry, actorId-namespaced) |
  | **Gateway** | Turns APIs/Lambdas/MCP servers into governed MCP tools; interceptors; credential providers |
  | **Identity** | Inbound auth (Cognito/Entra/Okta) + outbound OAuth to third-party tools on behalf of users |
  | **Policy** | **Cedar**-based policy engine at the Gateway: who can call which tool with which parameters; fine-grained access for Memory keyed on JWT claims |
  | **Memory** | Short-term + long-term memory, per-user namespaces |
  | **Code Interpreter / Browser** | Sandboxed tools |
  | **Observability / Evaluations** | OTel traces, quality evals |
  | **Payments** | Agent micropayments (x402, Stripe/Coinbase connectors) ⚠️ preview status |
- Data: prompts/outputs not used to train models; PrivateLink; KMS; CloudTrail.
- Related: SageMaker AI (custom training/hosting, HyperPod), **Kiro** (agentic IDE replacing Amazon Q Developer;
  Q Developer EOS 30 Apr 2027), Amazon Q Business & Kendra are **in maintenance**.

## Microsoft Foundry (Azure) — formerly Azure AI Foundry
- **Models**: 10,000+ in the Foundry catalog — Azure OpenAI (GPT family, reasoning models, embeddings, image,
  audio), Anthropic Claude, Meta, Mistral, DeepSeek, xAI, Microsoft models. Deployment types: Standard, Global
  Standard, Data Zone (EU/US residency), Provisioned (PTU), Batch.
- **Foundry Agent Service** (GA): three agent types — **prompt agents** (declarative), **voice-based prompt agents**
  (Voice Live; preview), **hosted agents** (bring your own code: Microsoft Agent Framework, LangGraph, OpenAI Agents
  SDK, Anthropic Agent SDK, GitHub Copilot SDK — container or .zip). Plus **Responses API** for agents running
  elsewhere.
- **Toolboxes**: curate tools (web search, file search, code interpreter, MCP servers, custom functions) once and
  share them via **a single managed MCP endpoint** with central auth, governance, versioning.
- Workflows (multi-agent orchestration), routines, **A2A**, **Entra agent identity**, **Entra Agent Registry**,
  Microsoft Agent 365 integration, agent optimizer (preview), CI/CD for hosted agents, tracing & evaluations with
  Application Insights, Foundry control plane (Entra, RBAC, network isolation, Azure Policy).
- **Classic agents (threads/runs API) deprecated → retire 31 Mar 2027**; migrate with the official guide.
- **Azure AI Search** for RAG (hybrid + semantic ranker + vector, integrated vectorization, agentic retrieval),
  **Azure AI Content Safety** (Prompt Shields, groundedness, protected material), APIM AI gateway policies (token
  limits, semantic caching, load-balancing PTU/PAYG), Copilot Studio for low-code agents.

## Google Cloud — Gemini Enterprise Agent Platform (formerly Vertex AI)
- Announced at Cloud Next '26 (22 Apr 2026): **Vertex AI rebranded/consolidated** into the Gemini Enterprise Agent
  Platform; all Vertex AI services and roadmap ship through it.
- Components: **Model Garden** (200+ models incl. Gemini and Claude), **ADK** (Agent Development Kit, code-first),
  **Agent Studio** (low-code), **Agent Engine** (managed runtime, sessions, memory bank), Vector Search, RAG Engine,
  Vertex AI Search, evaluation, **Model Armor** (prompt/response screening), grounding with Google Search,
  governance/security for agents, TPUs.
- **Gemini Enterprise**: workforce agent app (formerly Agentspace) connecting to Workspace/M365/SaaS data.

## Cross-platform agent standards (2026)
MCP is the default tool protocol on all three clouds (AgentCore Gateway, Foundry Toolboxes, Agent Platform);
**A2A** for agent-to-agent; OpenTelemetry GenAI conventions for tracing; Cedar (AWS) / Entra + Azure Policy (Azure) /
IAM + Model Armor (GCP) for agent authorization and guardrails.

## Selection guidance
| Driver | Lean toward |
|---|---|
| Existing cloud estate & security model | Same cloud's platform |
| Specific model need (Claude, GPT, Gemini) | All three now host Claude; GPT primarily Azure; Gemini primarily Google |
| India data residency | Verify in-Region model availability (ap-south-1/2, Central India, asia-south1/2) and that cross-Region/global inference is disabled where required |
| Enterprise search over M365 | Microsoft Foundry + Copilot ecosystem |
| Fine-grained tool authorization for agents | AgentCore Policy (Cedar) / Foundry Toolboxes + Entra agent identity |
| Multi-model routing across clouds | AI gateway (LiteLLM/Portkey/APIM) + abstraction layer |

## Exam relevance
AWS AIF-C01 / MLA-C02 / **AIP-C01** / AIB-C01; Microsoft AI-901 / **AI-103** / AI-200 / AI-300; Google Generative AI
Leader / Professional ML Engineer / PCA (AI-centric case studies).
