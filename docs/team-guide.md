# Team guide: consuming this marketplace

For teammates who want to use the plugins and skills from this repo in their own
projects. This repo holds no application code; it is a plugin marketplace.

## How this repo works

It is a **plugin marketplace**: a Git repo that AI coding tools treat as a
catalog of installable plugins. It currently ships one plugin, `architecture`,
with one skill, `draft-adr`, which drafts and validates an Architecture
Decision Record.

Three layers:

1. **Marketplace catalogs** (same content, one per tool family):
   - `.claude-plugin/marketplace.json` — read by Claude Code and GitHub Copilot CLI
   - `.agents/plugins/marketplace.json` — read by Codex

   Each lists the plugins and where to fetch them (`source` points to
   `./plugins/architecture`).
2. **Plugin manifests** — `plugins/architecture/.claude-plugin/plugin.json` and
   `.codex-plugin/plugin.json`. Same metadata twice because the tools read
   different files. The plugin is the **unit of install**: you cannot install a
   single skill from a marketplace, only a plugin that bundles skills.
3. **Skills** — `plugins/architecture/skills/draft-adr/SKILL.md` plus a
   validator script (bash and PowerShell) and reference docs. A skill is a
   folder whose `SKILL.md` tells the agent when and how to do a task.

**Versioning:** the version is repeated in the marketplace entries and both
manifests; CI fails if they drift. To release, bump all of them and push —
consumers get the new version on their next `/plugin marketplace update`.

**What this repo does not do:** it does not touch your machine by itself.
Nothing is installed until you add the marketplace in your tool.

## Using it in your repo

You do not clone this repo. The tools fetch it from GitHub directly.

### Option A — install once per user and machine

```
# Claude Code
/plugin marketplace add luis-sanchez-navarro/samx-package
/plugin install architecture@architect-skills

# Codex
codex plugin marketplace add luis-sanchez-navarro/samx-package

# GitHub Copilot CLI
copilot plugin marketplace add luis-sanchez-navarro/samx-package
copilot plugin install architecture@architect-skills
```

After that, in any repo, ask *"Draft an ADR: ..."* and the agent picks up the
skill. To get updates: `/plugin marketplace update` (Codex and Copilot CLI have
equivalent update commands).

### Option B — make it automatic for the repo (recommended for teams)

Commit a `.claude/settings.json` in the **consuming** repo:

```json
{
  "extraKnownMarketplaces": {
    "architect-skills": {
      "source": { "source": "github", "repo": "luis-sanchez-navarro/samx-package" }
    }
  },
  "enabledPlugins": { "architecture@architect-skills": true }
}
```

Anyone opening that repo in Claude Code gets prompted to trust the marketplace
and enable the plugin — no manual commands. This file is Claude Code-specific;
Codex and Copilot CLI users still use the Option A commands once.

### Option C — vendor the skill, no marketplace

Copy `plugins/architecture/skills/draft-adr` into the consumer's
`.claude/skills/` (or `.github/skills/` for Copilot in VS Code). Simple, works
offline, but updates are manual copies. Use it only when you do not want the
marketplace dependency.

**Rule of thumb:** Option B for repos the whole team works in, Option A for
personal setups, Option C for locked-down environments.
