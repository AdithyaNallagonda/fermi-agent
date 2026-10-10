# Model Hosting & Inference Optimization
Last reviewed: 2026-10 ⚠️ GPU SKUs/prices change quickly

## Managed API vs self-hosted
| Factor | Managed API (Bedrock, Azure OpenAI/Foundry, Vertex, Anthropic, OpenAI) | Self-hosted (open weights on GPUs) |
|---|---|---|
| Time to value | Minutes | Weeks |
| Cost at low/medium volume | Lower (pay per token) | Higher (idle GPUs) |
| Cost at very high steady volume | Can be higher | Can be lower with high utilization |
| Control/customization | Limited (some fine-tuning) | Full (fine-tune, quantize, custom decoding) |
| Data residency/sovereignty | Region-dependent | Full control (air-gapped possible) |
| Ops burden | None | High (GPU capacity, scaling, upgrades) |
Provisioned throughput / reserved capacity options exist on managed platforms for guaranteed TPM.

## GPU basics
Model memory ≈ params × bytes/param (FP16/BF16 = 2 bytes → 70B ≈ 140 GB; INT8 ≈ 70 GB; 4-bit ≈ 35–40 GB)
+ **KV cache** (grows with batch × context length) + activations. Families: NVIDIA H100/H200/B200/GB200,
L4/L40S (inference, cost-efficient), A10G; AWS Trainium/Inferentia2 (Neuron SDK); Google TPUs; AMD
MI300X. Tensor parallelism across GPUs for large models.

## Serving engines
**vLLM** (PagedAttention, continuous batching, prefix caching, broad model support), **SGLang**
(RadixAttention, structured outputs), TensorRT-LLM + Triton (NVIDIA-optimized), Hugging Face TGI
(maintenance mode ⚠️), llama.cpp/Ollama (CPU/edge/local), NVIDIA NIM (packaged microservices), LMDeploy.
Platforms: SageMaker endpoints (incl. inference components, LMI containers), Bedrock Custom Model Import,
EKS/AKS/GKE with KServe / Ray Serve / llm-d ⚠️, Azure ML online endpoints, Vertex AI endpoints, Modal/
Baseten/Together/Fireworks (serverless GPU providers).

## Optimization levers
- **Quantization**: INT8/FP8, 4-bit (AWQ, GPTQ), KV-cache quantization — 2–4× memory savings, small
  quality loss (evaluate!).
- **Continuous batching** (throughput ↑), **paged KV cache**, **prefix/prompt caching** (shared system
  prompts), **speculative decoding** (draft model; 2–3× decode speedup), FlashAttention, chunked prefill,
  disaggregated prefill/decode at scale.
- Smaller/distilled models for narrow tasks; **model routing/cascades** (cheap model first, escalate).
- Limit max tokens; streaming for perceived latency; structured outputs to shorten responses.

## Capacity planning
Measure tokens/s per GPU at target latency (TTFT p95, inter-token latency) for your prompt/output length
distribution; size replicas for peak concurrency; autoscale on queue depth/GPU utilization (KEDA);
warm pools (model load can take minutes); multi-AZ.

## Cost math example
1M requests/day × (1,500 input + 300 output tokens). Managed price assumption $3/M in, $15/M out →
1.5B × $3/M + 0.3B × $15/M = $4,500 + $4,500 = **$9,000/day**. With 80% prompt-cache hits on a 1,200-token
prefix at ~90% discount → input cost drops substantially. Compare with self-hosting: GPUs needed ×
$/GPU-hour × 24 at achieved throughput. Always present both with assumptions ⚠️ prices illustrative.

## Interview angles
Why is decode memory-bandwidth-bound; KV cache sizing; serving a 70B model on 2×80GB GPUs (BF16 won't
fit with KV cache comfortably → FP8/INT4 or 4 GPUs); latency vs throughput trade-off with batching.
