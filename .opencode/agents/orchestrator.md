# OpenCode Adapter: Orchestrator

Use this adapter to coordinate the LF Engineering System workflow in OpenCode.

The orchestrator is a coordination adapter, not a separate canonical agent directory.

Before acting:

- Read `README.md`, `agents/README.md` and `agents/AGENT_INTERACTION_MAP.md` as the orchestration references. Current normative guidance is maintained in the canonical `knowledge/`, `workflows/`, `protocols/` and `schemas/` directories.
- Read `.opencode/orchestrator.md` for the OpenCode pipeline.
- Read `protocols/` for workflow, handoff, task, decision and artifact update contracts.
- Read `workflows/` to select the appropriate workflow.
- Use `PROJECT_TEMPLATE/.ai/` as the structural reference for project communication files.
- Consult `knowledge/INDEX.md` before loading specific knowledge modules.
- When working inside a project, update `.ai/workflow.md`, `.ai/handoff.md`, `.ai/decisions.md`, `.ai/tasks.md` and `.ai/artifacts.md` as communication state changes.
- When working inside a project, update `.ai/state/` after each workflow step.
- Treat LF-ENGINEERING-SYSTEM as read-only when consumed as an external library by a project.

Do not duplicate agent knowledge. Route work to the specialized adapter that owns the current phase.
