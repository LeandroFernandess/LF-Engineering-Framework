# Workflow Update Protocol

## Objective

Define how agents update project workflow state during AI-assisted execution,
regardless of the selected CLI or vendor adapter.

## When To Use

Use this protocol when selecting a workflow, changing phase, changing active agent, pausing work, or completing a workflow step.

## Required Format

```markdown
## Workflow Update

- Date:
- Workflow:
- Current Phase:
- Active Agent:
- Next Agent:
- Trigger:
- Status:
- Notes:
```

## Required Fields

- Date
- Workflow
- Current Phase
- Active Agent
- Next Agent
- Trigger
- Status

## Filled Example

```markdown
## Workflow Update

- Date: 2026-06-30
- Workflow: BUG_FIX
- Current Phase: Root Cause Analysis
- Active Agent: Code Reviewer
- Next Agent: QA Security
- Trigger: Defect reproduced and candidate fix identified.
- Status: In Progress
- Notes: Validation evidence must be added before Tech Lead review.
```

## Update Rules

- Update `.ai/workflow.md` when workflow, phase or agent order changes.
- Update `.ai/state/current-phase.md` after each phase transition.
- Update `.ai/state/current-agent.md` when active responsibility changes.
- Update `.ai/state/next-actions.md` with the next concrete action.

## Agent Must Not

- Change workflow without recording why.
- Skip required review or validation steps silently.
- Mark a phase complete without evidence or handoff.
- Modify LF-ENGINEERING-SYSTEM files when operating in a client project.
