# Agent Handoff Protocol

## Objective

Define how one agent transfers context, decisions, open questions and next actions to another agent.

## When To Use

Use this protocol whenever work moves from one agent to another, when an agent stops before completion, or when responsibility changes inside a project.

## Required Format

```markdown
## Handoff

- Date:
- From Agent:
- To Agent:
- Workflow:
- Current Phase:
- Summary:
- Completed Work:
- Pending Work:
- Decisions:
- Risks:
- Required Next Actions:
- Related Artifacts:
```

## Required Fields

- Date
- From Agent
- To Agent
- Current Phase
- Summary
- Required Next Actions
- Related Artifacts

## Filled Example

```markdown
## Handoff

- Date: 2026-06-30
- From Agent: Product Owner
- To Agent: Software Architect
- Workflow: STANDARD_DEVELOPMENT
- Current Phase: Product Definition Complete
- Summary: PRD scope is ready for technical design.
- Completed Work: MVP, requirements and acceptance criteria drafted.
- Pending Work: Architecture design and technical risk assessment.
- Decisions: MVP excludes payment integration.
- Risks: Authentication requirements are still broad.
- Required Next Actions: Produce `docs/ARCHITECTURE.md` and identify ADR candidates.
- Related Artifacts: `docs/PRD.md`, `.ai/decisions.md`
```

## Update Rules

- Update `.ai/handoff.md` before the next agent begins.
- Update `.ai/state/current-agent.md` with the receiving agent.
- Update `.ai/state/current-phase.md` with the next phase.
- Link related project artifacts instead of copying full documents.

## Agent Must Not

- Hide unresolved assumptions.
- Transfer responsibility without naming the next required action.
- Duplicate entire framework documents inside project files.
- Modify LF-ENGINEERING-SYSTEM files when operating in a client project.
