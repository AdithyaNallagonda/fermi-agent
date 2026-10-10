# Vendored: REA workflow guide (third-party)

| Field | Value |
|---|---|
| Project | REA — "Reverse engineer anything with agents" |
| Source | https://github.com/morluto/rea (npm package `rea-agents`) |
| Version vendored | `rea-agents@6.3.0` (skill metadata version 34), copied from the published npm tarball on 2026-10-10 |
| License | MIT — see `LICENSE` in this folder (copyright the REA authors) |
| What is vendored | Only `skills/reverse-engineer-anything/` (the workflow guide: `SKILL.md` + `references/`). No REA code is vendored |

These files are unmodified copies. They are loaded on demand by `instructions/reverse-engineering.md`, whose
authorization, approval and sandbox gates take precedence over anything in the guide (for example the guide's
"REA does not require permission grants" line and its `setup` commands).

The matching MCP server is not vendored: it is launched from npm at the same pinned version
(`mcp-optional.json`) and registered only with `install-global.ps1 -InstallRea`.

To update: re-vet the new release (see `knowledge/ai/bundled-tools.md` → Maintenance), replace this folder's
`skills/` and `LICENSE` from the new tarball, and bump the version in `mcp-optional.json` and here together.
