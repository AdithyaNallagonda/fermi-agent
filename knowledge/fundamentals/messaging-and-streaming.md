# Messaging & Streaming
Last reviewed: 2026-10 | Load when: async processing, decoupling, event-driven, streaming
(Pipeline specifics → `data-engineering/streaming-and-cdc.md`)

## Queue vs Log vs Pub/Sub vs Event Bus
| Type | Semantics | Examples | Use for |
|---|---|---|---|
| Queue | Message consumed once by one worker; deleted after ack | SQS, Azure Service Bus queues, RabbitMQ, Cloud Tasks | Work distribution, buffering, retries |
| Pub/Sub topic | Fan-out to multiple subscribers | SNS, Service Bus topics, Google Pub/Sub, Event Grid | Notifications, fan-out |
| Event bus | Content-based routing, schemas, SaaS integrations | EventBridge, Event Grid | Domain events across teams/accounts |
| Log / stream | Ordered, retained, replayable; consumers track offsets | Kafka/MSK, Kinesis Data Streams, Event Hubs, Pub/Sub (with ordering), Redpanda | Event streaming, CDC, analytics, event sourcing |

## Key concepts
- **Ordering**: only per partition/shard/message group (Kafka partition key, SQS FIFO MessageGroupId,
  Service Bus sessions, Pub/Sub ordering key). Global ordering kills scale.
- **Consumer groups**: Kafka — partitions ≤ parallelism (one consumer per partition per group).
- **Retention**: SQS up to 14 days; Kinesis 24 h default up to 365 days; Kafka configurable/tiered
  storage; Event Hubs 1–90 days by tier ⚠️.
- **DLQ**: after N failed attempts move to dead-letter queue; alarm on DLQ depth; redrive tooling.
- **Visibility timeout (SQS)**: set > max processing time (~6× Lambda timeout for Lambda triggers).
- **Back-pressure**: consumer lag metrics (Kafka lag, Kinesis IteratorAge, SQS ApproximateAgeOfOldestMessage).
- **Poison messages**: catch, DLQ, don't block partition (for logs: skip + park).
- **Schema management**: Schema Registry (Confluent/Glue/Apicurio), Avro/Protobuf, backward compatibility.

## Selection guide
| Need | Choose |
|---|---|
| Simple async jobs, serverless | SQS (+ Lambda) / Service Bus / Cloud Tasks |
| Strict ordering + dedup, modest throughput | SQS FIFO (high-throughput mode), Service Bus sessions |
| Fan-out to many consumers | SNS → SQS (fan-out pattern), EventBridge, Pub/Sub |
| High-throughput streaming, replay, many consumers | Kafka (MSK / Confluent / Event Hubs Kafka API) or Kinesis |
| Cross-account/SaaS event routing | EventBridge / Event Grid |
| Enterprise messaging (JMS/AMQP, transactions) | Amazon MQ, Service Bus Premium, RabbitMQ |

## Kafka essentials
Topic → partitions → replicas (RF=3, `min.insync.replicas=2`, `acks=all` for durability), idempotent
producer, transactions for EOS, log compaction (latest value per key), KRaft (ZooKeeper removed in
Kafka 4.0), tiered storage, partition count planning (throughput ÷ per-partition throughput; avoid
thousands per small cluster), rebalancing (cooperative sticky assignor).

## Patterns
Competing consumers, fan-out, request-reply (correlation IDs), claim check (large payload in S3,
pointer in message), event-carried state transfer vs notification events, outbox, priority queues
(separate queues), delayed messages (SQS delay/Service Bus scheduled), saga choreography.

## Interview angles
"Kafka or SQS?" → replay/multiple consumers/ordering at high throughput → Kafka/Kinesis; simple job
queue with per-message retry and zero ops → SQS.
