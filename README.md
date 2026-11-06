# architect-skills (hello world)

A minimal, single-skill example of the layout described in
[hello-world-guide.md](hello-world-guide.md): one `draft-adr` skill, packaged
as the `architecture` plugin, with a validation script in both bash and
PowerShell.

```
.claude-plugin/marketplace.json            shared catalog (Claude Code + Copilot CLI)
plugins/architecture/
  .claude-plugin/plugin.json               Claude Code manifest
  .codex-plugin/plugin.json                Codex manifest
  skills/draft-adr/
    SKILL.md                               the skill
    scripts/check-adr.sh                   validator (macOS / Linux)
    scripts/check-adr.ps1                  validator (Windows)
    references/adr-template.md             layout the agent follows
    references/sample-adr.md               a valid ADR (used by CI)
.github/workflows/validate.yml             manifests + both scripts on Linux and Windows
.gitattributes                             LF for .sh, CRLF for .ps1
```

## Try the scripts

Both scripts take the same argument, print `OK` or one `ERROR: ...` line per
problem, and exit `0` / `1`.

```bash
cd plugins/architecture/skills/draft-adr
bash scripts/check-adr.sh references/sample-adr.md          # OK
bash scripts/check-adr.sh references/adr-template.md        # ERROR: ... too short
```

```powershell
cd plugins/architecture/skills/draft-adr
powershell -File scripts/check-adr.ps1 references/sample-adr.md
```

## Try the skill

**Claude Code** — from this folder:

```
/plugin marketplace add ./
/plugin install architecture@architect-skills
```

Or skip the plugin layer: `cp -r plugins/architecture/skills/draft-adr .claude/skills/`.

Then ask: *"Draft an ADR: we need to decide between REST and GraphQL for our
new partner API."* See section 11 of the guide for the three test inputs and
section 14 for Codex and Copilot CLI commands.
