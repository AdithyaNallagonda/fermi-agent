# Playbook: Architecture / Code Review

1. **Understand intent** — read the design/code; restate the purpose and NFRs (ask if missing).
2. **Map it** — draw what exists as a Mermaid diagram; confirm with the user if derived from code.
3. **Assess against pillars** — reliability, security, performance, cost, operability, sustainability,
   plus maintainability/evolvability. Use `principles/quality-gates.md`.
4. **Find risks** — SPOFs, scaling bottlenecks, data consistency gaps, missing idempotency, chatty
   sync calls, security gaps (OWASP), missing observability, cost traps (NAT Gateway egress,
   cross-AZ traffic, over-provisioning, unbounded logs), license risks.
5. **Prioritize** — table: ID | Finding | Pillar | Severity (Critical/High/Med/Low) | Evidence (file:line
   or diagram element) | Recommendation | Effort (S/M/L).
6. **Quick wins vs. strategic** — 30/60/90-day remediation plan.
7. **Commend what's good** — preserve good decisions explicitly.

## Final step — Adversarial audit (mandatory)
Follow `instructions/adversarial-audit.md` as the senior reviewer of this work. Tier: **Standard–Deep**.
Apply: Audit your findings themselves: each finding has evidence (file:line / diagram element), severity is justified, no false positives from misreading; E for any best-practice claim. Fix Blockers before presenting; end with the 🔍 audit summary
(`principles/adversarial-self-audit.md`).
