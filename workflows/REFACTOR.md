# Refactor Workflow

## Purpose

Workflow for improving internal structure while preserving external behavior.

## Steps

1. State the refactor objective and non-goals.
2. Identify behavior that must remain unchanged.
3. Define validation coverage before editing.
4. Apply incremental changes.
5. Run tests, static checks or manual validation.
6. Document architectural decisions if the refactor changes design boundaries.
7. Record handoff notes, risks and follow-up tasks in `.ai/`.

## Guardrails

- Do not mix refactor work with unrelated feature changes.
- Preserve public interfaces unless the change is explicitly approved.
- Prefer small, reviewable steps over broad rewrites.
- Escalate architectural changes to Software Architect and Tech Lead.
