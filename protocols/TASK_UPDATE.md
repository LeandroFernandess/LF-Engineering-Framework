# Task Update Protocol

## Objective

Define how agents create, update and close executable project tasks.

## When To Use

Use this protocol when adding tasks, changing task status, blocking work, completing work, or splitting a task.

## Required Format

```markdown
## Task Update

- Date:
- Task ID:
- Title:
- Owner:
- Status:
- Change Type:
- Context:
- Acceptance Criteria:
- Dependencies:
- Next Action:
```

## Required Fields

- Date
- Task ID
- Title
- Owner
- Status
- Change Type
- Next Action

## Filled Example

```markdown
## Task Update

- Date: 2026-06-30
- Task ID: TASK-003
- Title: Add authentication validation tests
- Owner: QA Security
- Status: Ready
- Change Type: Created
- Context: Authentication risk identified during architecture review.
- Acceptance Criteria: Invalid credentials, expired token and missing token cases are covered.
- Dependencies: Architecture decision for token strategy.
- Next Action: Implement validation tests after ADR approval.
```

## Update Rules

- Update `.ai/tasks.md` whenever task status changes.
- Update `.ai/state/next-actions.md` when the task affects immediate execution.
- Record blockers in `.ai/state/risks.md` when they affect delivery or quality.
- Keep task entries short and traceable to artifacts.

## Agent Must Not

- Create vague tasks without acceptance criteria.
- Mark blocked tasks as done.
- Hide dependencies or risk.
- Modify LF-ENGINEERING-SYSTEM files when operating in a client project.
