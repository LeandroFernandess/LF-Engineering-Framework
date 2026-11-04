# Project Agents

## Purpose

This file is the default project instruction entrypoint for AI assistants. It
explains how LF Engineering System agents should operate inside this project.
Read `LF_ENGINEERING.md` for the vendor-neutral project context.

## Agent Source

Use the canonical agent definitions from the LF Engineering System path recorded
in `LF_ENGINEERING.md`:

- `agents/Prompt-Architect/`
- `agents/Engineering-Manager/`
- `agents/Product-Owner/`
- `agents/Design-System-Analyst/`
- `agents/Software-Architect/`
- `agents/Sprint-Planner/`
- `agents/Documentation/`
- `agents/Code-Reviewer/`
- `agents/QA-Security/`
- `agents/Tech-Lead/`
- `agents/Engineering-Knowledge-Extractor/`

## Operating Rules

- Read `LF_ENGINEERING.md` before starting work.
- Consult `knowledge/INDEX.md` before loading specific knowledge modules.
- Consult `.ai/contracts.md` before creating, updating or validating project artifacts.
- Keep `.ai/` files current during work.
- Keep `.ai/state/` updated after each workflow step.
- `.ai/state/` is local and ignored by Git by default; do not force-add it unless
  specific files have been reviewed and explicitly approved for sharing.
- Keep decisions traceable to `docs/ADR.md` when they affect architecture, scope or delivery risk.
- Prefer focused handoffs between agents over duplicating full context in every response.
- For web or visual projects, use `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md` and `protocols/PERFORMANCE_VALIDATION.md` to keep mobile and desktop performance evidence separate.
- When motion is in scope, also load `knowledge/ENGINEERING_MOTION_DESIGN.md` and record its conditional review in the performance report; do not add motion or select a library by default.
- For non-trivial changes, require an approved plan naming affected files, tests, acceptance criteria, risks and exclusions before editing.
- Treat `ENGINEERING_ELEPHANT_GOLDFISH`, `ENGINEERING_AGENT_GRAPH_FLOW`, `ENGINEERING_RTK` and `ENGINEERING_GRAPHIFY` as approved optional supplemental references only; they are not mandatory dependencies or default tools, and this status does not authorize external-tool installation or integration.

## Project Boundary Rules

- The project repository is the only editable area by default.
- Treat LF-ENGINEERING-SYSTEM as an external read-only engineering library.
- Consult LF-ENGINEERING-SYSTEM only when framework, workflow, protocol, schema or agent guidance is needed.
- Do not alter LF-ENGINEERING-SYSTEM files during execution inside this project.
- If a framework change appears necessary, stop and ask for explicit confirmation outside the client project workflow.

## State Updates

After each step, update the relevant files:

- `.ai/state/current-phase.md`
- `.ai/state/current-agent.md`
- `.ai/state/project-summary.md`
- `.ai/state/next-actions.md`
- `.ai/state/risks.md`

Use `protocols/` from LF-ENGINEERING-SYSTEM to keep workflow, handoff, task and artifact updates consistent. The project may use any compatible AI assistant or CLI; do not assume vendor-specific commands or configuration unless an adapter is explicitly installed.

## Artifact Contracts

Before selecting or executing an agent step, read `.ai/contracts.md` and confirm that required upstream artifacts exist or that any exception is recorded in `.ai/decisions.md`.
