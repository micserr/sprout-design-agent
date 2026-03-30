# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.0.0 (2026-03-30)


### Features

* add pre-flight check, token enforcement, and stack context header to prototype skill ([f214576](https://github.com/micserr/sprout-design-agent/commit/f21457651eb142fe153ff172099cce9279da118b))
* add stack discovery at Phase 3→4 transition in product design agent ([f607c7a](https://github.com/micserr/sprout-design-agent/commit/f607c7a8939f7d6a65583aa22c96b447c5bb17ff))
* add Toge token mapping YAML for prototype code generation ([3c5d0c0](https://github.com/micserr/sprout-design-agent/commit/3c5d0c0bf2f7051ba2762ad51cfd0af4f82556b5))
* add ui-polish as Phase 6 in product design agent ([c7e00a4](https://github.com/micserr/sprout-design-agent/commit/c7e00a4ff539c83483cf7b1828ee5101cfa5018a))
* add ui-polish skill, Toge v2 tokens, and missing assets ([d17ba46](https://github.com/micserr/sprout-design-agent/commit/d17ba46ca8b56fd6b0b9f359e1bdddbe2d692fc8))
* add ui-polish skill, Toge v2 tokens, and missing assets ([305b39e](https://github.com/micserr/sprout-design-agent/commit/305b39e3947f611aaa51211d7c8400129bd3cfd4))
* officialize Toge v1/v2 naming and add toge: skill prefix ([af6c366](https://github.com/micserr/sprout-design-agent/commit/af6c366c9f73cf9911228b50c4d04f29597af76c))
* officialize Toge v1/v2 naming and add toge: skill prefix ([cab4c2f](https://github.com/micserr/sprout-design-agent/commit/cab4c2fc8079be76dfa91da1af27db8d5ea913c6))


### Bug Fixes

* add border border-gray-100 to wireframe bento card constraint ([a09de09](https://github.com/micserr/sprout-design-agent/commit/a09de09e2d69626a199461f9cc6ae20867ba470a))
* make ui-polish performance.md framework-agnostic ([a863834](https://github.com/micserr/sprout-design-agent/commit/a863834f60a162bb80100d1b4241bfdf5f95642c))

## [Unreleased]

## [0.3.0] - 2026-03-24

### Added
- `ui-polish` skill — Phase 6 of the design agent workflow covering typography, surfaces, animations, and performance
- Phase 6 UI Polish to product design agent orchestrator
- `CODE_OF_CONDUCT.md` and `CONTRIBUTING.md`
- `CHANGELOG.md`

### Changed
- Toge v2 installation guide rewritten from official source (`github.com/Aiah-Ai/toge-ds-components`)
- `performance.md` in ui-polish made framework-agnostic (React + Vue examples)
- Wireframe bento card constraint updated to include `border border-gray-100`

## [0.2.0] - 2026-03-23

### Added
- Stack discovery (Phase 3→4 transition) — auto-detects Toge v1 vs v2 from `package.json` and `components.json`
- Stack context header (`// Stack: ...`) written as first line of every prototype
- Pre-flight check (Step 0) in prototype skill — 4 agnostic failure pattern checks
- `guide/toge-design-system-v2/tokens/token-mapping.yaml` — default Tailwind → Toge token substitution map

### Changed
- Toge v2 token enforcement updated in prototype skill and agent
- Guide paths updated throughout after directory rename

## [0.1.0] - 2026-03-22

### Added
- Initial skills: `ux-market-research`, `problem-framing`, `user-journey`, `wireframing`, `prototype`, `design-tokens`, `design-qa`
- Product design agent with dual-mode (Advisor + Orchestrator) and 5-phase workflow
- Guide directories for Toge v1 (`design-system-next`) and Toge v2 (shadcn-vue registry)
- Adapters for Claude Code, Codex CLI, Cursor, and BMAD
- `install.sh` for multi-framework installation

### Changed
- Renamed "Sprout Legacy" → "Toge v1" and "Toge" → "Toge v2" across all files
- Added `toge:` prefix to `wireframing` and `prototype` skill names
- Repo renamed to `sprout-design-agent`

[Unreleased]: https://github.com/micserr/sprout-design-agent/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/micserr/sprout-design-agent/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/micserr/sprout-design-agent/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/micserr/sprout-design-agent/releases/tag/v0.1.0
