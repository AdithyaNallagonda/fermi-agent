# LLM Fundamentals
Last reviewed: 2026-10 ⚠️ model names/context windows/prices change monthly — verify live

## How LLMs work (tutor-ready)
1. **Tokenization**: text → subword tokens (BPE/SentencePiece). ~4 chars ≈ 1 token in English; Indic
   scripts often cost more tokens per word.
2. **Embeddings + Transformer layers**: self-attention lets each token weigh every other token (cost
   O(n²) in sequence length; mitigated by FlashAttention, sliding windows, etc.). Decoder-only models
   predict the next token.
3. **Pre-training** on huge corpora → **post-training** (instruction tuning/SFT, preference optimization
   RLHF/DPO, RL with verifiable rewards for reasoning) → aligned assistant.
4. **Inference**: prefill (process prompt, compute KV cache) → decode (one token at a time, reusing KV
   cache). Latency = TTFT (prefill) + output tokens ÷ tokens-per-second.
5. **Sampling**: temperature, top-p, top-k; low temperature for extraction/deterministic tasks.
6. **Reasoning models / extended thinking**: spend extra tokens thinking before answering; better on
   complex tasks, higher latency/cost.

## Key parameters for architects
Context window (tokens in + out), max output tokens, rate limits (RPM/TPM), pricing per million input/
output tokens (output typically 3–5× input), prompt caching discounts, batch API discounts (~50%),
multimodality (images, PDFs, audio), tool/function calling, structured outputs (JSON schema),
data residency and retention terms.

## Model families (landscape — verify current versions)
Anthropic Claude (Opus/Sonnet/Haiku), OpenAI GPT series & o-series, Google Gemini, Meta Llama (open
weights), Mistral, Cohere Command (RAG), Amazon Nova, DeepSeek, Qwen, Microsoft Phi (small). Open-weight
models enable self-hosting & fine-tuning; licenses vary.

## Prompt engineering essentials
- Clear role/task, context, constraints, output format; examples (few-shot) for format/style.
- Separate instructions from data with delimiters/XML tags; put long documents first, question last.
- Ask for structured output (JSON schema / tool use) for machine consumption.
- Chain of thought / thinking for complex reasoning; prompt chaining for multi-step pipelines.
- Prompt caching: stable prefix (system prompt, tools, documents) first to maximize cache hits.
- Version prompts; test against an eval set before changing.

## Customization ladder
Prompting → RAG (knowledge) → tool use (actions/fresh data) → fine-tuning (format, tone, domain style,
smaller-model distillation, latency/cost) → continued pre-training (rare). LoRA/QLoRA for parameter-
efficient fine-tuning of open models. Fine-tuning does not reliably teach new facts — use RAG.

## Embeddings
Dense vectors representing meaning (e.g., 256–3072 dims); cosine similarity; models: Titan/Nova, Cohere
Embed (multilingual), OpenAI text-embedding-3, Gemini embedding, open (BGE, E5, GTE, Nomic). Matryoshka
embeddings allow truncating dimensions for cost. Re-embed corpus when changing models.

## Evaluation
Task metrics (accuracy, F1, exact match), LLM-as-judge with rubrics (calibrate against humans), RAG
metrics (faithfulness, answer relevance, context precision/recall — RAGAS), safety evals, latency/cost.
Golden datasets + regression gates in CI.

## Interview angles
Explain attention/KV cache simply; why output tokens cost more and are slower; temperature effects;
when fine-tuning vs RAG; how to reduce hallucinations (grounding, citations, abstention, evals).
