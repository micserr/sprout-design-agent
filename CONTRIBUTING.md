# Contributing to sprout-design-agent

Thanks for improving this repo. Keep changes focused, small, and purposeful.

---

## Getting Started

1. Fork the repo and clone your fork
2. Create a branch from `main` (see Branch Naming below)
3. Make your changes
4. Commit using the Conventional Commits format (see below)
5. Update `CHANGELOG.md` under `[Unreleased]`
6. Open a PR against `main`

---

## Branch Naming

Pattern: `<type>/<short-kebab-description>`

| Prefix | Purpose | Example |
|---|---|---|
| `feat/` | New skill, agent feature, or capability | `feat/add-design-qa-skill` |
| `fix/` | Bug fix | `fix/prototype-path-resolution` |
| `docs/` | Documentation only | `docs/update-toge-install-guide` |
| `chore/` | Tooling, deps, config, adapters | `chore/add-cursor-adapter` |
| `refactor/` | Restructure without behavior change | `refactor/skill-frontmatter-cleanup` |
| `perf/` | Performance improvement | `perf/reduce-agent-context-size` |

**Rules:**
- Always lowercase, hyphens only
- 3–5 words max after the prefix
- Branch off `main` — no long-lived branches
- Delete branch after merge

---

## Commit Messages

This repo uses the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) spec.

### Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

- **type** — required, lowercase
- **description** — required, imperative mood, lowercase, no trailing period
- **body** — optional, free-form, separated by one blank line
- **footer** — optional; `BREAKING CHANGE:` must be uppercase exactly

### Commit Types

| Type | When to use | SemVer impact |
|---|---|---|
| `feat` | New skill, new agent phase, new capability | MINOR |
| `fix` | Bug in a skill, agent logic, or adapter | PATCH |
| `docs` | README, guide, or inline documentation only | — |
| `refactor` | Restructure without adding features or fixing bugs | — |
| `chore` | Adapter scripts, tooling, config, dependencies | — |
| `style` | Formatting, whitespace — no logic change | — |
| `perf` | Performance improvement | — |
| `revert` | Reverts a previous commit | depends |

### Examples

```bash
# New skill
feat: add design-qa skill for pre-handoff review

# Scoped feature
feat(agent): add Phase 6 UI polish to orchestrator workflow

# Bug fix
fix: resolve symlink collision when re-running install.sh

# Docs update
docs: rewrite Toge installation guide from official source

# Chore
chore: add ui-polish to claude adapter symlinks

# Breaking change (footer)
feat: rename guide/toge-design-system-v2 to guide/toge-design-system

BREAKING CHANGE: guide directory paths have changed — update any local references

# Breaking change (inline)
feat!: remove the wireframing phase from the orchestrator workflow
```

---

## Changelog

This repo uses [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format.

**Every PR must update `CHANGELOG.md`** — add an entry under `[Unreleased]` before opening the PR.

### Sections (use only what applies)

| Section | When to use |
|---|---|
| `Added` | New skills, phases, guides, or capabilities |
| `Changed` | Updates to existing behavior or content |
| `Deprecated` | Things being phased out in a future release |
| `Removed` | Deleted skills, guides, or features |
| `Fixed` | Bug fixes |
| `Security` | Vulnerability patches |

### Format

```markdown
## [Unreleased]

### Added
- `ui-polish` skill — Phase 6 of the design agent workflow

### Changed
- Toge installation guide rewritten from official source
```

Do not dump `git log` output into the changelog. Write for humans.

---

## Pull Requests

### Title format

Match Conventional Commits exactly — this feeds the changelog:

```
feat(agent): add Phase 6 UI polish to orchestrator workflow
fix: resolve Windows path issue with relative skills
docs: update Toge installation guide
```

### Rules

- **One purpose per PR** — no mixing feat + docs + fix in a single PR
- **Small diff** — under ~400 lines where possible; split larger changes
- **CI must pass** before requesting review
- **Self-review** your own diff before requesting review
- **CHANGELOG.md updated** under `[Unreleased]`

### Merge policy

- Maintainer merges, not the author
- Squash merge to `main` to keep history linear
- Delete branch after merge

---

## What Belongs Here

This repo contains:
- **Skills** (`skills/`) — markdown files that extend Claude Code
- **Agent** (`agents/`) — the product design orchestrator
- **Guides** (`guide/`) — reference documentation for AI agents
- **Adapters** (`adapters/`) — installer scripts for different AI frameworks

**Do not add:**
- Product-specific business logic
- Hardcoded project paths or secrets
- Skills that duplicate existing ones without clear differentiation

---

## Semantic Versioning

| What changed | Version bump |
|---|---|
| Breaking change (`BREAKING CHANGE:` or `!`) | MAJOR (X.0.0) |
| New skill or agent capability (`feat:`) | MINOR (0.X.0) |
| Bug fix (`fix:`) | PATCH (0.0.X) |
| Docs, chore, refactor, style, perf | No bump |
