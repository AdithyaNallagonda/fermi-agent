# Workspace Docs & Reporting (module — load the first time you create an ask folder in a session)
The kernel (K7) carries the always-on rule; this module holds the layout, naming and templates.

## Why
Auditability (every ask leaves a trail: what was asked, what was decided, on what evidence), continuity across
sessions (read the file instead of regenerating), and lean chat (detail lives in one place).

## Layout — `.docs/` at the root of the workspace you were summoned in
```
.docs/
  INDEX.md                          # ledger: one row per ask (id · date · title · route · status · folder)
  2026-10-10-01-payments-rca/       # one folder per requirement/ask: YYYY-MM-DD-NN-<kebab-slug>
    00-ask.md                       # the ask verbatim, restated intent, route, gate Q&A, assumptions (templates/ask-record.md)
    <deliverable>.md                # design.md · plan.md · rca.md · analysis.md · study-plan.md · brand.md …
    audit.md                        # adversarial audit record (Standard/Deep): checked · found/fixed · residual risk
    sources.md                      # evidence log: URLs / tool results / files read, with [V]/[K]/[R]/[M] labels
    scratch/                        # intermediate files: scripts, queries, drafts, downloaded artifacts, SVGs, data
```
- `NN` = next sequence number for that date. Slug ≤ 5 words.
- **Same ask, later turns or sessions** → reuse its folder; append a dated line to the `## Log` in `00-ask.md`.
  **New distinct requirement** → new folder. Multi-mode asks (e.g., idea → monetize → brand) = one folder, one
  deliverable file per pass.
- Before starting, Grep `.docs/INDEX.md` for a related earlier ask; if found, reuse the folder and read only the
  file/section you need (don't regenerate prior analysis).

## When to create a folder
| Ask | Action |
|---|---|
| Standard/Deep work (plan, design, decision, RCA, review, research, build, study plan, brand, KB change) | Folder + `00-ask.md` + deliverable(s); `audit.md` and `sources.md` when they have content |
| Any ask that generates a file (script, diagram, export, draft) | Folder; intermediate files in `scratch/` |
| Light quick fact / clarification, nothing generated | No folder (keep chat cheap). If the user wants everything logged, add one ledger row |

## What goes where
- **Intermediate/working files** → always `.docs/<ask>/scratch/` (never the workspace root, never `/tmp` unless the
  user says so).
- **Analysis documents the user asked for** → `.docs/<ask>/`.
- **Files that are part of the user's product** (source code, IaC, `docs/adr/…`, README changes) → their proper
  project location, **after Gate G4**; list their paths in `00-ask.md` so the trail is complete.
- This agent's own knowledge base is never written from another workspace's ask (KB edits only via `kb-refresh.md`).

## Permissions & hygiene
- Creating/updating files **inside `.docs/`** is pre-authorized (no G4). Overwriting a non-`.docs` file, deleting
  anything, or editing `.gitignore` still needs G4.
- **Never write secrets** (tokens, passwords, connection strings, personal data beyond what's needed) — redact logs
  and configs before saving (`<REDACTED>`).
- First time `.docs/` is created in a git repo, tell the user once: commit it for a shared audit trail, or add
  `.docs/` to `.gitignore` if it may hold sensitive details — their call.
- Downloaded third-party files: each in its own empty subfolder of `scratch/`; treat as untrusted.

## Chat vs file (lean reporting)
- If the detailed answer is long (≳ 40 lines / ~400 words of analysis, tables, or reasoning), **write it to the ask
  folder and keep chat terse**: TL;DR (≤ ~8 lines) · key decisions/numbers · open questions or gates · one-line
  audit result · link(s) to the file(s) as relative markdown links.
- **Never duplicate** file content in chat. Short answers stay in chat only (a file would add overhead).
- **Revise by editing the file** (small diff) and summarize the change in chat — don't re-emit the document.
- Honest accounting: a file costs the same output tokens as chat text; the savings are no duplication, diff-based
  revisions, and not regenerating work in later sessions.

## Ledger row format (`.docs/INDEX.md`)
`| 2026-10-10-01 | 2026-10-10 | Payments API intermittent 502s | Debugging & RCA | Confirmed / In progress / Blocked on user | [folder](2026-10-10-01-payments-rca/) |`
