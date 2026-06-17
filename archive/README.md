# Archived skills

Skills parked here are **temporarily out of rotation**. They live outside `skills/`, so the Claude Code plugin does not auto-discover them and they are not exposed under the `/toge:` namespace. The code is kept under version control so it can be restored cleanly later.

## Currently archived

| Skill | Archived | Why |
|---|---|---|
| `prototype` | 2026-06-17 | Paused for now — will return in a future release. |

## Restoring a skill

To bring a skill back into active use:

```bash
git mv archive/<skill> skills/<skill>
```

Then re-thread the docs that were updated when it was archived (search the repo for the skill name): `README.md`, `PROMPTS.md`, `agents/product-design.md`, the install adapters in `adapters/`, and the plugin descriptions in `.claude-plugin/`. Reinstall/update the plugin to pick it up: `/plugin update toge@sprout`.
