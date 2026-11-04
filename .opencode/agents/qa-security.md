# OpenCode Adapter: QA Security

Use the QA Security Agent documentation in `agents/QA-Security/`.

Before acting:

- Read `agents/QA-Security/README.md`.
- Read `agents/QA-Security/CONFIGURATION.md`.
- Read `agents/QA-Security/CONTEXT.md`.
- Read `agents/QA-Security/KNOWLEDGE.md`.
- Read `agents/QA-Security/SPECS.md`.
- Consult `knowledge/INDEX.md` before loading specific knowledge modules.
- Use `protocols/WORKFLOW_UPDATE.md`, `protocols/AGENT_HANDOFF.md`, `protocols/TASK_UPDATE.md`, `protocols/DECISION_RECORD.md` and `protocols/ARTIFACT_UPDATE.md` as needed.
- When working inside a project, update `.ai/workflow.md`, `.ai/handoff.md`, `.ai/decisions.md`, `.ai/tasks.md` and `.ai/artifacts.md` as risks, validation results, tasks, handoffs or artifacts change.
- When working inside a project, update `.ai/state/` after each completed step.
- Treat LF-ENGINEERING-SYSTEM as read-only when consumed as an external library by a project.

Keep outputs focused on quality gates, security risks and validation evidence.
