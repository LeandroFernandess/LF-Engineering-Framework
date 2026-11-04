# Project Agents

## Purpose

This file explains how LF Engineering System agents should operate inside this project.

## Agent Source

Use the canonical agent definitions from the LF Engineering System:

- `agents/Engineering-Manager/`
- `agents/Prompt-Architect/`
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

- Consult `knowledge/INDEX.md` before loading specific knowledge modules.
- In client projects, consult `.ai/contracts.md` before creating, updating or validating project artifacts.
- Client projects must keep `.ai/` and `.ai/state/` current during work; the public Framework root keeps maintainer history outside the publication surface.
- Keep decisions traceable to `docs/ADR.md` when they affect architecture, scope or delivery risk.
- Prefer focused handoffs between agents over duplicating full context in every response.
- For web or visual projects, use `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md` and `protocols/PERFORMANCE_VALIDATION.md` to keep mobile and desktop performance evidence separate.
- When motion is in scope, use `knowledge/ENGINEERING_MOTION_DESIGN.md` for the conditional motion contract and review; do not add a library or mandatory workflow phase by default.

## Project Boundary Rules

- The project repository is the only editable area by default.
- Treat LF-ENGINEERING-SYSTEM as an external read-only engineering library.
- Consult LF-ENGINEERING-SYSTEM only when framework, workflow, protocol, schema or agent guidance is needed.
- Do not alter LF-ENGINEERING-SYSTEM files during execution inside this project.
- If a framework change appears necessary, stop and ask for explicit confirmation outside the client project workflow.

## State Updates

In client projects, after each step update the relevant files:

- `.ai/state/current-phase.md`
- `.ai/state/current-agent.md`
- `.ai/state/project-summary.md`
- `.ai/state/next-actions.md`
- `.ai/state/risks.md`

Use `protocols/` from LF-ENGINEERING-SYSTEM to keep workflow, handoff, task, decision and artifact updates consistent. Framework-root changes use `docs/ADR.md`, `CHANGELOG.md` and the publication documentation as the public record.

## Artifact Contracts

Before selecting or executing an agent step in a client project, read `.ai/contracts.md` and confirm that required upstream artifacts exist or that any exception is recorded in `.ai/decisions.md`.
