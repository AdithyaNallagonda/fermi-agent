# Observability
Last reviewed: 2026-10 | Load when: monitoring, tracing, alerting, SLOs, incident response

## Pillars
- **Metrics**: cheap, aggregated, alertable (Prometheus, CloudWatch, Azure Monitor, Cloud Monitoring).
- **Logs**: structured JSON with correlation/trace IDs; sampling for high-volume debug logs.
- **Traces**: distributed request flow; spans with attributes; tail-based sampling keeps errors/slow.
- Plus **profiles** (continuous profiling) and **events** (deploys, config changes).

## Frameworks
- **Golden signals** (Google SRE): latency, traffic, errors, saturation.
- **RED** (services): Rate, Errors, Duration.
- **USE** (resources): Utilization, Saturation, Errors.

## OpenTelemetry (default choice)
Vendor-neutral SDKs + OTel Collector (receive → process → export). W3C Trace Context propagation.
Exporters to CloudWatch/X-Ray (ADOT), Azure Monitor/Application Insights, Google Cloud Trace,
Grafana (Tempo/Loki/Mimir), Datadog, New Relic, Elastic/OpenSearch.

## Alerting
Alert on symptoms (SLO burn) not causes; every page actionable with a runbook link; route by severity;
avoid alert fatigue (review noisy alerts monthly).

## Cost control
Log retention tiers, sampling, drop debug in prod, metric cardinality limits (no user IDs as labels),
archive logs to object storage + query with Athena/BigQuery/Log Analytics Basic logs.

## Incident management
Severity matrix, incident commander, comms channel, status page, timeline; blameless postmortem
(impact, root cause(s), contributing factors, action items with owners). Measure MTTD, MTTR.

## AI/LLM observability
Trace prompts, retrieved context, tool calls, tokens, latency (TTFT), cost per request, eval scores,
user feedback (Langfuse, Arize Phoenix, LangSmith, OpenLLMetry, cloud-native options).
