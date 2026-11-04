# LF Engineering System Context

This project uses the LF Engineering System as an external, read-only
engineering library.

## Framework Location

The canonical Framework is installed at
`__LF_ENGINEERING_SYSTEM_PATH__`. Use that path when loading the agent,
knowledge, workflow, protocol and schema directories listed below.

## Canonical Sources

Consult the Framework's `knowledge/INDEX.md` before loading specific knowledge,
`knowledge/REGISTRY.md` before selecting agents or handoffs, and
`.ai/contracts.md` before creating or validating project artifacts.

The canonical Framework directories are:

- `agents/`: agent responsibilities and behavior.
- `knowledge/`: reusable engineering guidance.
- `workflows/`: lifecycle workflows.
- `protocols/`: handoff, task, decision and artifact update rules.
- `schemas/`: artifact structures and validation expectations.

## Project Boundary

- Work only inside the client project.
- Treat the LF Engineering System as read-only.
- Keep project-specific state in `.ai/` and project artifacts in `docs/`.
- Ask for confirmation before destructive operations.
- Require an approved plan before non-trivial implementation changes.

## Workflow

Use the Engineering Manager and Orchestrator to classify work and select the
workflow. Use specialized agents as needed, then route review, QA/security,
documentation and delivery readiness through the Tech Lead.

For web or visual projects, use the design-performance knowledge module and
validate mobile and desktop evidence separately. For non-visual projects,
record performance validation as not applicable instead of inventing browser
metrics.

When motion is in scope, also use `knowledge/ENGINEERING_MOTION_DESIGN.md` to
define the motion contract and conditional QA review. The module does not
prescribe an animation library or add a workflow phase.

The same context can be loaded by any AI assistant or CLI. Vendor-specific
adapters are optional and must not replace this document.
