# Playbook: Knowledge Base Refresh (self-update)

Use when the user asks to update/audit the knowledge base, or quarterly. This is the one playbook that writes into
KB_ROOT.

## Step 1 — Scope
Default scope = files marked ⚠️ in `knowledge/INDEX.md`, prioritized: certifications → career market → cloud AI
platforms → cloud service lifecycle (`cloud/aws.md` lifecycle table, Azure retirements) → framework versions
(frontend/backend/data) → regulations (`enterprise/regulatory-architecture.md`). The user may name specific files.

## Step 2 — Gather facts from primary sources (in this order of trust)
1. Official docs via MCP: `aws-knowledge` / `aws-docs` (use `current_awareness` topic; AWS "Service Availability
   Updates" and Product Lifecycle page), `microsoft-learn` (retired-exams page, "What's new", retirement FAQs).
2. Official vendor/standards sites via WebFetch: aws.amazon.com/certification/*, learn.microsoft.com/credentials,
   cloud.google.com/learn/certification, pmi.org (ECO PDFs via markitdown), scaledagile.com, owasp.org,
   kubernetes.io/blog, endoflife.date, regulator sites (meity.gov.in, rbi.org.in, sebi.gov.in, cert-in.org.in).
3. WebSearch (`extended` for niche/recent) only to discover; confirm claims on a primary source before writing.
   Treat exam-dump/marketing/AI-generated blogs as unreliable (they invented "SAA-C04" in 2026).

> **Audit checkpoint (E, Deep) — before editing anything:** each proposed change has a primary source read
> this session (not just a search snippet or model summary); secondary-only claims stay ⚠️.

Efficiency: docs-MCP search chunks are verbatim page text — use them directly; fetch full pages only for
enumerations or when chunks lack the fact; batch independent searches; one script for bulk replacements.

**Gate G4**: show the proposed change table (file · old → new · source) and get approval before editing.

## Step 3 — Update files
- Edit only the stale statements; keep file structure and density.
- Update the `Last reviewed:` line with the date and the source used ("verified against … on YYYY-MM-DD").
- Remove ⚠️ when verified on a primary source; add ⚠️ to anything only secondary-sourced.
- Propagate changes: grep the KB for the old term (exam codes, product names) and fix every occurrence,
  including `instructions/` and `knowledge/INDEX.md`.
- New topics → new file + INDEX row.

## Step 4 — Report
Table: File | What changed | Source (URL) | Confidence. List anything that couldn't be verified. Suggest the next
refresh date (default: 90 days; 30 days for certifications during announced transitions).

## Final step — Adversarial audit (mandatory)
Follow `instructions/adversarial-audit.md` as the senior reviewer of this work. Tier: **Deep**.
Apply: E (primary-source corroboration for every changed fact), C (diff review, grep for every old term, link/INDEX check), then re-audit the change report itself for overstated confidence. Fix Blockers before presenting; end with the 🔍 audit summary
(`principles/adversarial-self-audit.md`).
