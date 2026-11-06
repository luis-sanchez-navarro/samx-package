# architect-skills

A plugin marketplace for solution architects, usable from Claude Code, Codex and
GitHub Copilot CLI. It currently ships one plugin, `architecture`, with one
skill, `draft-adr`, which drafts an Architecture Decision Record and validates
it with a script (bash and PowerShell versions).

## Layout

```
.claude-plugin/marketplace.json            catalog for Claude Code + Copilot CLI
.agents/plugins/marketplace.json           catalog for Codex
.claude/settings.json                      auto-registers the marketplace for Claude Code users of this repo
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

How the files relate:

- A marketplace file is a catalog. It lists plugins and where to find them.
- A `plugin.json` describes one plugin. Plugins are installed as `plugin@marketplace-name`.
- A plugin bundles skills under `skills/<name>/SKILL.md`.
- Individual skills are not installed on their own through a marketplace; the plugin is the unit.

## Install (team members)

No clone is needed. The tools fetch the repo from GitHub.

**Claude Code**

```
/plugin marketplace add luis-sanchez-navarro/samx-package
/plugin install architecture@architect-skills
/plugin marketplace update
```

Inside a clone of this repo, `.claude/settings.json` registers the marketplace
and enables the plugin; Claude Code prompts to install it when the folder is
trusted. To get the same in your own project, copy that file into the project's
`.claude/settings.json`.

**Codex**

```
codex plugin marketplace add luis-sanchez-navarro/samx-package
```

Then install `architecture` from the plugin directory in Codex.

**GitHub Copilot CLI**

```
copilot plugin marketplace add luis-sanchez-navarro/samx-package
copilot plugin install architecture@architect-skills
```

Copilot CLI reads `.claude-plugin/marketplace.json`.

**Skills only, no plugin:** copy `plugins/architecture/skills/draft-adr` into
`.claude/skills/` (Claude Code, and Copilot in VS Code) or `.github/skills/`.

Private forks work as long as the user has git access to the repo.

## Try locally

From a clone of this repo:

```
/plugin marketplace add ./
/plugin install architecture@architect-skills
```

Then ask: *"Draft an ADR: we need to decide between REST and GraphQL for our
new partner API."*

## Run the validator

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

## Add a plugin or skill

- New skill in an existing plugin: add `plugins/architecture/skills/<name>/SKILL.md`.
- New plugin: create `plugins/<name>/` with both manifests, then add an entry to
  `.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json`.
- Reference a plugin hosted in another repo: in `.claude-plugin/marketplace.json`
  use `"source": { "source": "github", "repo": "<org>/<repo>" }`.
- Keep the version equal in the manifests and the marketplace entry (CI checks this).

## License

MIT
