# Agentic Systems, Tool Use & MCP
Last reviewed: 2026-10 ⚠️ protocols and frameworks evolving rapidly

## Definitions
- **Workflow**: LLM calls orchestrated through predefined code paths (predictable).
- **Agent**: LLM dynamically decides steps and tool calls in a loop until goal/stop condition.
Start with the simplest: single call → prompt chain → routing → parallelization → orchestrator-workers →
evaluator-optimizer → autonomous agent. Add autonomy only when it measurably improves outcomes.

## Agent loop anatomy
Goal + context → model chooses action (tool call) → execute tool → observe result → update state/memory →
repeat → final answer. Guards: max iterations, token/cost budget, timeouts, loop detection, HITL
checkpoints, structured final output.

## Tool design (most important quality lever)
- Few, well-named, high-level tools with clear descriptions and examples; precise JSON schemas.
- Return concise, relevant results (pagination, filtering) — tool outputs consume context.
- Idempotent where possible; explicit side-effect tools separated from read tools.
- Errors as informative messages the model can act on.
- AuthZ inside tools using the *end user's* identity/scopes (not a god service account).

## Model Context Protocol (MCP)
Open protocol (introduced by Anthropic, Nov 2024; broadly adopted across vendors) for connecting AI
applications (hosts/clients) to **servers** exposing **tools**, **resources**, and **prompts**.
Transports: stdio (local) and Streamable HTTP (remote; replaced HTTP+SSE). Remote servers use OAuth 2.1
authorization. Security: verify server provenance, pin versions, review tool descriptions (tool poisoning),
least-privilege scopes, sandbox local servers, log calls. Registries/catalogs for discovery ⚠️.

## Agent-to-Agent (A2A)
Protocol (Google-initiated, Linux Foundation) for agents to discover (Agent Cards) and delegate tasks to
other agents across vendors. MCP = agent↔tools/data; A2A = agent↔agent.

## Memory
Short-term (conversation/context window, summarization/compaction), long-term (vector store of facts,
user preferences, episodic logs), procedural (learned instructions/skills). Managed: Bedrock AgentCore
Memory, Microsoft Foundry Agent Service (session state persistence), Agent Engine memory bank (Gemini Enterprise Agent Platform). Guard against memory
poisoning; allow user inspection/deletion.

## Multi-agent patterns
Supervisor/orchestrator with specialist sub-agents (context isolation, parallelism), hierarchical teams,
debate/critic (evaluator-optimizer), handoffs (swarm). Costs: more tokens (often several × single-agent),
coordination failures, harder debugging. Use when tasks are parallelizable or need context isolation.

## Frameworks & platforms
Claude Agent SDK, OpenAI Agents SDK, LangGraph, LlamaIndex Workflows, CrewAI, AutoGen/AG2 → Microsoft
Agent Framework (Semantic Kernel + AutoGen convergence ⚠️), Google ADK, Strands Agents (AWS), PydanticAI.
Runtimes (verified 2026-10): **Amazon Bedrock AgentCore** (Runtime with per-session microVMs, **harness** managed
loop, Gateway, Identity, **Policy (Cedar)**, Memory, Code Interpreter, Browser, Observability, Evaluations),
**Microsoft Foundry Agent Service** (prompt/voice/hosted agents, Toolboxes as managed MCP endpoints, Entra agent
identity, A2A), **Gemini Enterprise Agent Platform** (ADK, Agent Studio, Agent Engine, memory bank). Legacy paths
in maintenance/deprecation: Bedrock Agents Classic, Foundry classic agents (retire 31 Mar 2027).

## Enterprise agent governance pattern (converging across clouds)
1. **Identity per agent** (Entra agent ID / AgentCore Identity / service identity) + user delegation (OAuth OBO).
2. **Central tool hub** exposing tools as MCP behind a gateway (AgentCore Gateway / Foundry Toolbox / APIM).
3. **Policy at the gateway** (Cedar/OPA/Azure Policy): which agent may call which tool with which parameters, for
   which user — evaluated *before* execution.
4. **Agent registry/catalog** (Entra Agent Registry, internal catalog) with owners, versions, risk tier.
5. **Observability + evals** as release gates; audit log of every tool call.
6. **Kill switch & budgets** per agent and per tenant.

## Evaluation & observability
Trajectory evals (did it call the right tools in a sensible order?), task success rate, cost & latency per
task, safety evals, regression suites with recorded tool fixtures; tracing every step (OpenTelemetry GenAI
semantic conventions, Langfuse, LangSmith, Phoenix).

## Production checklist
Clear success criteria; sandboxed execution; scoped credentials per user; approval for irreversible
actions; budgets; retries with idempotency; audit logs; fallback to human; prompt-injection defenses
(content from tools/web is untrusted); versioned prompts/tools; canary releases of agent changes.

## Building Claude Code agents (meta)
See `instructions/agent-factory.md` and `templates/agent-template.md`: `.claude/agents/*.md` subagents
(frontmatter: name, description, tools, model), skills in `.claude/skills/*/SKILL.md`, MCP servers via
`.mcp.json`, hooks in settings.
