# LF Engineering System

Languages: [EN-US](README.md) | [PT-BR](README.pt-BR.md)

The LF Engineering System is a framework for AI-assisted software engineering. It defines engineering principles, reusable knowledge, specialized agents, workflows, protocols, schemas and project bootstrap templates.

The system is designed to be consumed by client projects as an external read-only engineering library.

This repository is the clean first public snapshot, released as `v1.5.0`. The
earlier private repository history, branches and tags were intentionally not
migrated; `v1.4.0` is historical context, not a release tag in this repository.

## Core Documents

- `docs/reference/LF_DESIGN_PERFORMANCE_GUIDE.md`: detailed Portuguese design/performance
  reference; adopted operational requirements are defined in the canonical
  knowledge module and protocol.
- `START_PROJECTS.en-US.md`: official English setup guide.
- `locales/pt-BR/public-docs/START_PROJECTS.md`: official PT-BR setup guide.
- `FIRST_PROMPT_TEMPLATE.md`: optional copy-ready first prompt for starting a
  project conversation after cloning the Framework.
- `AGENTS.md`: project-level agent operating rules.
- `ROADMAP.md`: planned framework evolution.
- `CHANGELOG.md`: implemented framework changes.
- `OVERVIEW.md`: current release status, publication context and future graph-interface direction.
- `locales/pt-BR/public-docs/OVERVIEW.md`: overview and publication context in PT-BR.
- `docs/ADR.md`: architectural decisions and publication policy.
- `locales/pt-BR/public-docs/ROADMAP.md`: roadmap translation in PT-BR.
- `locales/pt-BR/public-docs/CHANGELOG.md`: changelog translation in PT-BR.
- `locales/pt-BR/docs/ADR.md`: architecture decision records in PT-BR.
- `CONTRIBUTING.md`: contribution and validation rules.
- `locales/pt-BR/public-docs/CONTRIBUTING.md`: contribution guidance in PT-BR.
- `SECURITY.md`: security expectations and private reporting guidance.
- `locales/pt-BR/public-docs/SECURITY.md`: security guidance in PT-BR.
- `TESTING.md`: local and CI test matrix.
- `locales/pt-BR/public-docs/TESTING.md`: local and CI test matrix in PT-BR.
- `locales/pt-BR/public-docs/`: translated public documentation.

## Repository Structure

```text
.
├── README.md
├── README.pt-BR.md
├── AGENTS.md
├── START_PROJECTS.en-US.md
├── PROJECT_TEMPLATE/
├── agents/
├── knowledge/
├── workflows/
├── protocols/
├── schemas/
├── adapters/
├── scripts/
├── docs/
│   └── ADR.md
├── locales/
│   ├── en-US/README.md
│   └── pt-BR/
│       ├── PROJECT_TEMPLATE/
│       ├── agents/ knowledge/ workflows/ protocols/ schemas/
│       ├── public-docs/
│       └── docs/ADR.md
├── .github/
└── .opencode/
```

## Main Areas

- `PROJECT_TEMPLATE/`: base structure copied into new client projects.
- `adapters/`: optional integrations for specific AI assistants or CLIs.
- `scripts/`: native macOS/Linux and Windows PowerShell bootstrap commands.
- `locales/`: PT-BR mirrors and public translations; EN-US canonical technical
  files remain in the root. `locales/en-US/README.md` is an index only.
- `agents/`: canonical documentation for every LF Engineering System agent.
- `knowledge/`: reusable engineering knowledge consumed by agents.
- `workflows/`: official workflow definitions for project work.
- `protocols/`: update protocols for workflow, handoff, tasks, decisions and artifacts, including conditional mobile/desktop performance and motion validation for web and visual projects.
- `schemas/`: canonical structures for engineering artifacts.
- `.opencode/`: Framework-side OpenCode compatibility source; client installation
  is optional and is managed through `adapters/opencode/`.
- `PROJECT_TEMPLATE/.ai/`: client-project coordination and state files copied by the bootstrap.
- `docs/`: Framework governance decisions and audit evidence.
- `docs/reference/`: non-normative source guides retained for provenance.
- `.github/`: CI validation and contribution templates.

## New and Existing Projects

Use `START_PROJECTS.en-US.md` or
`locales/pt-BR/public-docs/START_PROJECTS.md` to create a new project or safely
adopt an existing project. The default model is:

1. Create a separate project directory.
2. Run `scripts/bootstrap.sh` or `scripts/bootstrap.ps1` with `--adapter
   generic` (or the equivalent PowerShell parameter).
3. Select `en-US` or `pt-BR` explicitly.
4. Keep this framework external and read-only.
5. Run the workflow through Engineering Manager, Orchestrator, specialized
   agents, Tech Lead and Engineering Knowledge Extractor.

The generated `.gitignore` keeps `.ai/state/` local by default. Existing
projects retain their own `.gitignore` during bootstrap and must adopt this rule
manually if desired.

For an existing project, use the same bootstrap in dry-run mode first. It copies
only missing template files and preserves existing project documents and
configuration.

## Operating Rules

- Do not modify this framework from inside a client project unless explicitly approved.
- Keep framework changes traceable through `docs/ADR.md`, `CHANGELOG.md` and the publication documentation.
- Keep `knowledge/INDEX.md` and `knowledge/REGISTRY.md` aligned with available knowledge modules and agents.
- Keep `PROJECT_TEMPLATE/` aligned with the official startup workflow.
- Prefer incremental framework evolution based on real project evidence.
- For web or visual projects, keep performance evidence separate for mobile and desktop; do not treat automated scores as guarantees.
- When motion or an explicitly requested model-driven interactive visual simulator is in scope, use the conditional guidance; no animation library, 3D pipeline or simulator is a Framework default.

## CLI compatibility

The Framework is CLI-neutral by default. OpenAI Codex can use `AGENTS.md`;
Anthropic Claude Code can use `CLAUDE.md`; Google Gemini CLI can use `GEMINI.md`;
OpenCode can use the optional `opencode.jsonc` adapter. No adapter changes the
canonical Framework.

See `adapters/README.md` for the adapter matrix and `.opencode/README.md` for
Framework-side OpenCode compatibility details.

PT-BR template coverage and remaining translation work are documented in
`locales/pt-BR/TRANSLATION_STATUS.md`.

The canonical technical source remains EN-US in the root module directories;
PT-BR mirrors and translated public documents are grouped under `locales/pt-BR/`.
