---
name: draft-adr
description: >
  Draft an Architecture Decision Record from discussion notes or a rough
  description. Use when the user asks to write, create, or draft an ADR.
  Do not use for reviewing or approving existing ADRs.
compatibility: >
  Validation needs bash (macOS / Linux / Git Bash) or PowerShell (Windows).
---

You are helping a solution architect produce a structured ADR.

## Steps

1. Ask the user for the decision context if it is not already provided.
2. Identify the status: Proposed, Accepted, Deprecated, or Superseded.
3. Draft the ADR using the sections below. Follow the layout in
   `references/adr-template.md`.
4. Validate the draft (see **Validation**).
5. Ask the user to confirm or revise before finalising.

## Required sections

- **Title** — short imperative phrase (e.g. "Use PostgreSQL for the event store")
- **Status** — Proposed | Accepted | Deprecated | Superseded
- **Context** — the forces and constraints driving this decision
- **Decision** — what was decided and why
- **Consequences** — positive, negative, and neutral outcomes
- **Open Questions** — unresolved items that need a follow-up decision

## Rules

- Do not invent technical details not present in the user's notes.
- Keep each section concise — bullets over paragraphs.
- If the user's notes are too thin to fill a section, insert a placeholder
  and flag it explicitly.
- If no decision was reached, keep Status `Proposed` and say so explicitly
  in the Decision section.

## Validation

After drafting, save the ADR to a temporary file and validate it. Script paths
are relative to this skill's directory.

- macOS / Linux: `bash scripts/check-adr.sh <file>`
- Windows:       `powershell -File scripts/check-adr.ps1 <file>`

The script prints `OK` and exits `0` on success, or prints one
`ERROR: <message>` line per problem and exits `1`. If it reports any ERROR
lines, correct the draft and rerun before presenting it to the user.
