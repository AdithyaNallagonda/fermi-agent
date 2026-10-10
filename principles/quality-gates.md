# Quality Gates (run before finalizing)

These checklists are the *minimum* content bar. They are applied inside the adversarial audit
(`principles/adversarial-self-audit.md` + `instructions/adversarial-audit.md`), which adds requirement
traceability, evidence labelling, diff/blast-radius review, execution evidence, and pre-mortems. Ticking a
box requires having actually checked it.

## Architecture / design answers
- [ ] Functional requirements + NFRs (latency, throughput, availability, durability, RPO/RTO) captured or assumed
- [ ] Back-of-envelope estimate present (QPS, storage, bandwidth)
- [ ] Data model and access patterns stated; store choice justified
- [ ] Failure modes + mitigations (single points of failure, retries, idempotency, DR)
- [ ] Security covered (identity, network, data, secrets, threat highlights)
- [ ] Observability (SLIs/SLOs, tracing, alerting)
- [ ] Cost estimate range + top cost drivers
- [ ] Trade-offs and alternatives rejected (with reason)
- [ ] Evolution path (what changes at 10×)
- [ ] Next actions

## Plans (idea→app, delivery, study plans)
- [ ] Clear goal and success metric
- [ ] Scope cut into phases/milestones with dates or durations
- [ ] Dependencies and risks (ROAM)
- [ ] Concrete first-week actions

## Tutoring
- [ ] Level-appropriate; analogy + mechanism + numbers + application
- [ ] Check-for-understanding question at the end

## Facts
- [ ] Volatile facts verified or flagged ⚠️
- [ ] No invented citations, limits, or prices
