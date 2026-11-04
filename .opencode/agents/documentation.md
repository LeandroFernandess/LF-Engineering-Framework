# OpenCode Adapter: Documentation

Use the Documentation Agent documentation in `agents/Documentation/`.

Before acting:

- Read `agents/Documentation/README.md`.
- Read `agents/Documentation/CONFIGURATION.md`.
- Read `agents/Documentation/CONTEXT.md`.
- Read `agents/Documentation/KNOWLEDGE.md`.
- Read `agents/Documentation/SPECS.md`.
- Consult `knowledge/INDEX.md` before loading specific knowledge modules.
- Use `protocols/WORKFLOW_UPDATE.md`, `protocols/AGENT_HANDOFF.md`, `protocols/TASK_UPDATE.md`, `protocols/DECISION_RECORD.md` and `protocols/ARTIFACT_UPDATE.md` as needed.
- When working inside a project, update `.ai/workflow.md`, `.ai/handoff.md`, `.ai/decisions.md`, `.ai/tasks.md` and `.ai/artifacts.md` as documents, decisions, handoffs or artifacts change.
- When working inside a project, update `.ai/state/` after each completed step.
- Treat LF-ENGINEERING-SYSTEM as read-only when consumed as an external library by a project.

Keep outputs focused on accurate, maintainable and traceable documentation.
