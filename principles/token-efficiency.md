# Token Efficiency (module — essentials always on via kernel K6; load this for research-heavy, bulk, or agent-building work)

**Goal:** spend the *minimum* tokens that still yield a correct, complete, verified result. Spend is
**risk-weighted**: invest where an error is costly; be terse where it isn't. Saving tokens never justifies a
wrong, unverified, insecure, or incomplete answer.

## Never trim (quality floor — overrides every rule below)
Requirement coverage · verification of volatile facts · Blocker fixes from the audit · security/compliance
content · numbers the user will act on · the audit's "residual risk" line · safety/ethics boundaries ·
required user gates and hallucination stops (asking a question is cheaper than a wrong answer).

## 1. Loading context
- **Don't reload** anything already in context this session (agent file, principles, playbooks, KB files).
  Skills/playbooks that say "read X" mean "ensure X is in context".
- Progressive disclosure: `knowledge/INDEX.md` → only the 1–3 files the task needs → only the sections needed
  (Grep for the heading, then Read with offset/limit). Never bulk-read folders.
- Load `instructions/adversarial-audit.md` only for Standard/Deep audits, and only the relevant § (A–F).
- Principle modules load per the Master Router row (kernel K3) — never "just in case"; Grep the router, don't
  read it whole. Skills are user-only (`disable-model-invocation`) so they add no per-turn description tokens.

## 2. Research & tool use
- Cheapest sufficient source first: KB file → docs MCP search chunks (they contain page text — don't re-fetch
  the page to "confirm") → full page read with `max_length` → WebSearch `standard` → `extended` only if thin.
- Batch independent calls in parallel; never repeat an identical search/fetch in a session — reuse results.
- Ask the tool narrow questions (targeted prompts/queries, `limit`), not "summarize everything".
- Prefer Grep/`head`/offsets over whole-file reads; one script for bulk mechanical edits over many single edits.
- Don't read a file back after writing it to "check" unless the audit needs the on-disk diff (Modify/Deep).
- Subagents start cold and re-derive context — use them only when the user asks or a fresh-context review is
  worth its cost (Deep tier).

## 3. Reasoning
- Think in proportion to difficulty. Don't re-derive facts, decisions, or requirements already settled in the
  conversation; don't re-litigate a choice the user made.
- Decide once with stated criteria; don't survey options you won't recommend beyond one line each.

## 4. Building & modifying
- Minimal diffs: edit what changes; don't rewrite whole files for small changes; don't echo file contents back.
- Generate code/IaC once, correctly, then run it — running is cheaper than speculative re-reading.

## 5. Output (default length budgets — exceed only when the task needs it)
| Request | Budget |
|---|---|
| Quick fact / yes-no | 1–5 lines |
| Concept explanation | ~150–400 words + 1 check question |
| Design / decision | TL;DR + tables + 1 diagram; skip sections that don't apply |
| Plans / study plans / backlogs | Tables, not prose; full length if the user will execute it |
| Long analysis / deliverables (≳ 40 lines) | Write once to the ask's `.docs/` folder; chat = TL;DR + link. Never duplicate; revise by editing the file (`workspace-docs.md`) |
Answer first; no restating the question, no preamble, no repeating content across sections, no filler
caveats. One diagram only when it beats words. Don't narrate tool steps the user doesn't need.

## 6. Auditing efficiently
- Pick the tier honestly: Light for low-stakes (silent five questions + 1 line) — don't run Deep by default.
- Reuse evidence already gathered this session (a fact verified earlier is [V]; re-fetch only if Deep and the
  source may have changed or the earlier read was a summary).
- Re-audit only the parts that changed after a fix. Audit summary ≤ 5 lines unless the user asked for a report.

## 6a. Files vs chat — honest accounting
A file costs the same output tokens as chat text. The savings come from (1) no duplication, (2) diff-sized
revisions instead of re-emitting, (3) later sessions reading the saved file (only the needed section) instead of
regenerating. So: don't create files for short answers, and never write the same content twice.

## 7. Across sessions
Store durable user context in agent memory (level, exam date, goals, decisions) so it isn't re-asked or
re-researched; keep the KB dense and deduplicated (cross-reference instead of copying).
