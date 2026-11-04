# Artifact Update Protocol

## Objective

Define how agents track project artifacts created, updated or consumed during a workflow.

## When To Use

Use this protocol whenever an agent creates, modifies, reviews or depends on a project artifact.

## Required Format

```markdown
## Artifact Update

- Date:
- Artifact:
- Path:
- Owner:
- Change Type:
- Status:
- Summary:
- Related Decisions:
- Next Action:
```

## Required Fields

- Date
- Artifact
- Path
- Owner
- Change Type
- Status
- Summary

## Filled Example

```markdown
## Artifact Update

- Date: 2026-06-30
- Artifact: Product Requirements Document
- Path: `docs/PRD.md`
- Owner: Product Owner
- Change Type: Updated
- Status: Ready for architecture
- Summary: Added MVP scope, goals and acceptance criteria.
- Related Decisions: MVP excludes payment integration.
- Next Action: Software Architect to produce `docs/ARCHITECTURE.md`.
```

## Update Rules

- Update `.ai/artifacts.md` after artifact creation or meaningful modification.
- Update `.ai/state/project-summary.md` when artifact changes alter the project summary.
- Update `.ai/state/next-actions.md` when artifact state changes the next step.
- Keep artifact status aligned with handoff and workflow state.

## Agent Must Not

- Claim an artifact is ready without a clear owner and status.
- Duplicate full artifact content into `.ai/artifacts.md`.
- Leave generated artifacts untracked.
- Modify LF-ENGINEERING-SYSTEM files when operating in a client project.
