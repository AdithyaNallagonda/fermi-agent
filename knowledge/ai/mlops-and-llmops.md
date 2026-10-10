# MLOps & LLMOps
Last reviewed: 2026-10

## Classic ML lifecycle
Problem framing → data collection/labeling → feature engineering (feature store: offline + online,
point-in-time correctness) → training (experiment tracking: MLflow, SageMaker Experiments, W&B) →
evaluation (offline metrics, fairness, explainability — SHAP) → registry (versioned models, approvals) →
deployment (batch, real-time endpoint, edge; shadow/canary/A-B) → monitoring (data drift, concept drift,
prediction quality, latency) → retraining triggers.

## Maturity levels (Google MLOps levels)
0: manual notebooks → 1: automated training pipelines with continuous training → 2: CI/CD for pipelines
themselves.

## Platforms
SageMaker AI (Pipelines, Feature Store, Model Registry, Model Monitor, Clarify, MLflow managed), Azure ML
(pipelines, registries, managed endpoints, responsible AI dashboard), Vertex AI (Pipelines, Feature Store,
Model Registry, Model Monitoring), Databricks (MLflow, Feature Engineering, Model Serving), Kubeflow, Metaflow,
Ray.

## LLMOps specifics
- **Prompt management**: versioned prompts in Git/registry; parameterized templates; change review.
- **Evaluation pipelines**: golden sets, LLM-as-judge rubrics, pairwise comparisons, safety/red-team
  suites; run in CI for every prompt/model/retrieval change; track quality vs cost vs latency.
- **Model upgrade playbook**: run evals on new model version, compare, canary, monitor, rollback plan.
- **Online monitoring**: user feedback (thumbs, edits), groundedness scores, refusal rates, toxicity,
  latency (TTFT), token usage per feature/tenant, cost anomalies, drift in query topics.
- **Fine-tuning ops**: dataset curation & lineage, PEFT (LoRA), eval before/after, model registry,
  serving adapters (multi-LoRA serving).
- **Gateways**: LiteLLM, Portkey, Kong AI Gateway, Azure API Management AI gateway policies, cloud-native
  routing — fallback across providers/regions, caching, rate limits, cost attribution.

## Responsible AI
Model cards, data sheets, bias testing, human oversight, transparency to users, incident reporting,
regulatory mapping (EU AI Act, NIST AI RMF, ISO 42001).

## Interview angles
Detecting drift without labels; online vs offline features; safe rollout of a new LLM version; measuring
RAG quality in production.
