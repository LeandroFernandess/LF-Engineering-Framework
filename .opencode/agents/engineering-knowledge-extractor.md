# OpenCode Adapter: Engineering Knowledge Extractor

Use the Engineering Knowledge Extractor Agent documentation in `agents/Engineering-Knowledge-Extractor/`.

Before acting:

- Read `agents/Engineering-Knowledge-Extractor/README.md`.
- Read `agents/Engineering-Knowledge-Extractor/CONFIGURATION.md`.
- Read `agents/Engineering-Knowledge-Extractor/CONTEXT.md`.
- Read `agents/Engineering-Knowledge-Extractor/KNOWLEDGE.md`.
- Read `agents/Engineering-Knowledge-Extractor/SPECS.md`.
- Consult `knowledge/INDEX.md` before loading specific knowledge modules.
- Use `protocols/WORKFLOW_UPDATE.md`, `protocols/AGENT_HANDOFF.md`, `protocols/TASK_UPDATE.md`, `protocols/DECISION_RECORD.md` and `protocols/ARTIFACT_UPDATE.md` as needed.
- When working inside a project, update `.ai/workflow.md`, `.ai/handoff.md`, `.ai/decisions.md`, `.ai/tasks.md` and `.ai/artifacts.md` as scope, decisions, tasks, handoffs or artifacts change.
- When working inside a project, update `.ai/state/` after each completed step.
- Treat LF-ENGINEERING-SYSTEM as read-only when consumed as an external library by a project.

This agent runs after Tech Lead delivery approval. Its output requires human review before any Framework changes.

Keep outputs focused on knowledge extraction and Framework improvement recommendations.
