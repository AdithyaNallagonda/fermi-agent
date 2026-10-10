# Playbook: Reverse Engineering (with REA)

Principles: `principles/security-principles.md`, `principles/ethics-and-boundaries.md`,
`principles/diagnostic-reasoning.md`, `principles/hallucination-guardrails-and-user-gates.md`.
Knowledge: `knowledge/ai/bundled-tools.md` (REA section) and the vendored REA workflow guide
`third_party/rea/skills/reverse-engineer-anything/SKILL.md` (+ `references/` — load only the one you need).
**Precedence:** this playbook's gates override the vendored guide (which says REA needs no approvals and
includes `setup` commands). REA is third-party, opt-in software: its tools appear as `mcp__rea__*` only after
the user ran `install-global.ps1 -InstallRea`; otherwise use the pinned CLI (`npx -y rea-agents@6.3.0 <command>`)
or tell the user how to enable it — don't run `rea setup` yourself.

## Step 1 — Authorization & purpose (Gate G1 — always, before touching the target)
Ask and record in `00-ask.md`:
1. **What is the target** (exact file/app/URL, version) and **who owns it**?
2. **Why**: debugging/RCA of own software · interoperability · migration/modernization of a system without
   source · security review or malware analysis of something you're responsible for · learning/CTF · supplier
   due diligence.
3. **Authority**: the user's own software, their employer's/client's with permission, open-source, or an
   authorized engagement. If the answer is unclear or it's someone else's proprietary product → stop and ask.
4. **Confidentiality**: analysis output is sent to the model provider — is that acceptable for this artifact?

**Decline** (explain why, offer a lawful alternative): defeating licensing/activation/DRM, cracks/keygens,
game cheats or anti-cheat bypass, extracting secrets/keys/credentials from others' software or devices,
finding exploitable bugs in systems the user isn't authorized to test, cloning a competitor's proprietary product,
anything against a live third-party service. Licence terms and anti-circumvention law vary by country — flag
"check the EULA and get legal advice" for anything commercial; this is not legal advice.

## Step 2 — Scope the question
Turn the ask into a checklist of concrete questions and the evidence each needs (e.g., "which endpoint does
feature X call", "what changed between v1 and v2", "where is this config read"). Prefer source, docs, logs and
vendor contact when they answer the question faster than decompilation.

## Step 3 — Choose the least invasive method
| Target | First choice (static, nothing runs) | Needs |
|---|---|---|
| Electron / JavaScript bundle / ASAR | `analyze_javascript_application` (or CLI `analyze-javascript-application <path> --json`) | Nothing extra |
| .NET assembly | `inspect_managed_artifact` | Nothing extra |
| Archive / package (ZIP, APK, MSIX…) inventory | `open_binary` + `inspect_artifact` | Nothing extra |
| Android APK code | `inspect_android_package` | JADX + JDK (user-installed) |
| Native binary (EXE/DLL/ELF/Mach-O) | `open_binary` → focused tools | Ghidra (+ JDK) or IDA, user-installed; Hopper is macOS/Linux |
| Website / web app you own | passive capture tools | Chrome-family browser |
| Saved HAR / network capture | `inspect_web_network_capture` | Nothing extra |
Static first. **Runtime/dynamic work (anything that launches, attaches to, or drives the target — process,
Electron, browser scenario, native UI capture) needs Gate G4**, and for untrusted or possibly malicious binaries
only inside a disposable VM/sandbox with no credentials and no network (or tell the user to do that step).
Never run an unknown binary on the user's main machine.

## Step 4 — Investigate (follow the vendored guide's method)
Route by target → summary first → focused follow-ups → reuse the session (no duplicate calls) → close native
sessions (`close_binary`). Missing engine/tool → say exactly what's needed (G3); installing Ghidra/JADX/etc. is
the user's decision (G4), never automatic. Write exports and evidence bundles only into the ask's
`.docs/<ask>/scratch/`.

## Step 5 — Report with evidence discipline
Separate **observations** (tool output, with REA Evidence IDs), **inferences**, and **unknowns**; keep REA's
stated limitations and coverage; never say static analysis "observed" behavior. Redact secrets, tokens, personal
data and proprietary code excerpts beyond what's needed. Deliverable: `reverse-engineering.md` in the ask folder
(question checklist with status answered / partial / unresolved, findings ledger, limits, next steps).

> **Audit checkpoint (E + B, Deep) — before presenting:** authorization recorded; every finding cites evidence;
> nothing executed without G4; no secrets or large proprietary excerpts in outputs; unanswered questions listed.

## Final step — Adversarial audit (mandatory)
Tier: **Deep**. Apply §E (each claim traces to tool evidence; limits preserved), §B (method choice — was the
least invasive option used?), §D if code was produced from findings. Any claim without evidence → tripwire STOP.
End with the 🔍 audit summary.
