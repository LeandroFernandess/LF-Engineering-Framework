# OpenCode Adapter: Design System Analyst

Use the Design System Analyst Agent documentation in `agents/Design-System-Analyst/`.

Before acting:

- Read `agents/Design-System-Analyst/README.md`.
- Read `agents/Design-System-Analyst/CONFIGURATION.md`.
- Read `agents/Design-System-Analyst/CONTEXT.md`.
- Read `agents/Design-System-Analyst/KNOWLEDGE.md`.
- Read `agents/Design-System-Analyst/SPECS.md`.
- Consult `knowledge/INDEX.md` before loading specific knowledge modules.
- Use `protocols/WORKFLOW_UPDATE.md`, `protocols/AGENT_HANDOFF.md`, `protocols/TASK_UPDATE.md`, `protocols/DECISION_RECORD.md` and `protocols/ARTIFACT_UPDATE.md` as needed.
- When working inside a project, update `.ai/workflow.md`, `.ai/handoff.md`, `.ai/decisions.md`, `.ai/tasks.md` and `.ai/artifacts.md` as scope, decisions, tasks, handoffs or artifacts change.
- When working inside a project, update `.ai/state/` after each completed step.
- Treat LF-ENGINEERING-SYSTEM as read-only when consumed as an external library by a project.

This agent runs for supplied reference analysis or when the user/Product Owner explicitly requests an initial direction without references for a visual product. Skip it when neither applies; a proposal must be marked `Proposed` and approved before becoming a baseline.

Keep outputs focused on design analysis and DESIGN.md production.
