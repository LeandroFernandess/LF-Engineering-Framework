---
name: lf-project-planning
description: Use to turn a client-project request into a scoped, reviewable plan before implementation.
---

# LF Project Planning

1. Read the project instructions, `.ai/contracts.md`, and current `.ai/state/`.
   Use the official Framework source identified in `LF_ENGINEERING.md`.
2. When the canonical repository is available, consult its `knowledge/INDEX.md`,
   `knowledge/REGISTRY.md`, and applicable workflow before loading agent definitions.
3. Check required upstream artifacts and record missing inputs or accepted
   exceptions. Select only the relevant agents, modules and protocols.
4. Define affected files, behavior, acceptance criteria, verification, risks
   and exclusions. Identify conditional artifacts only when their conditions
   apply.
5. Present the plan for approval before implementation. Do not infer approval
   from a draft, task list or prior unrelated approval.

Use `workflows/NEW_PROJECT.md` for initialization and
`workflows/STANDARD_DEVELOPMENT.md` for changes to an existing project. Keep
canonical Framework content external and read-only.
