# OpenCode Orchestrator

## Purpose

This file defines the main LF Engineering System pipeline for OpenCode usage.

The orchestrator coordinates specialized agents. It does not replace their documentation and should not duplicate their knowledge.

The orchestrator receives the `MANAGER_BRIEF` prepared by the Engineering Manager, selects the appropriate workflow, chooses the required agents and controls handoff until Tech Lead review.

## Main Pipeline

```text
Engineering Manager
    -> Orchestrator
    -> Prompt Architect (conditional)
    -> Product Owner
    -> Design System Analyst (conditional)
    -> Software Architect
    -> Sprint Planner
    -> Plan approval
    -> Implementation / selected CLI
    -> Code Reviewer
    -> QA Security
    -> Documentation
    -> Tech Lead
    -> Engineering Knowledge Extractor
```

## Operating Model

1. Receive and analyze the `MANAGER_BRIEF` from the Engineering Manager.
2. Consult `knowledge/REGISTRY.md` for agent responsibility, inputs, outputs and likely next agent.
3. Consult `.ai/contracts.md` when operating inside a project repository.
4. Confirm the work type classification or pause if it is `UNKNOWN`.
5. Select the matching workflow from `workflows/`.
6. Select the required agents for the work.
7. Determine execution order and current phase.
8. Update `.ai/workflow.md`.
9. Update `.ai/state/current-phase.md`.
10. Register handoffs in `.ai/handoff.md`.
11. Route execution through the selected agents.
12. Send the final result to Tech Lead for delivery readiness.

## Work Type Selection

| Work Type | Use When | Workflow |
| --------- | -------- | -------- |
| `NEW_PROJECT` | Starting a new project or generating the initial project structure | `workflows/NEW_PROJECT.md` |
| `BUG_FIX` | Diagnosing or correcting a defect | `workflows/BUG_FIX.md` |
| `REFACTOR` | Improving internal structure without changing intended behavior | `workflows/REFACTOR.md` |
| `DOCUMENTATION` | Creating, updating or reviewing documentation as the primary task | `workflows/DOCUMENTATION.md` |
| `STANDARD_DEVELOPMENT` | Building a feature or completing normal engineering work | `workflows/STANDARD_DEVELOPMENT.md` |

## Agent Selection

- Use Engineering Manager before Orchestrator to classify raw user demand and produce `MANAGER_BRIEF`.
- Before selecting agents, consult `knowledge/REGISTRY.md`.
- Before selecting a workflow inside a project, consult `.ai/contracts.md` to confirm artifact dependencies and required upstream inputs.
- Use Prompt Architect when the prompt, context or constraints are incomplete.
- Use Product Owner when scope, requirements, MVP or acceptance criteria must be defined.
- Use Design System Analyst when visual references need engineering documentation, or when the user/Product Owner explicitly requests an initial visual direction without references. Skip when neither applies; proposals remain optional and require approval before adoption.
- Use Software Architect when technical design, constraints, interfaces or trade-offs must be decided.
- Use Sprint Planner when work must be broken into executable tasks.
- Use Documentation when project artifacts must be created, updated or aligned.
- Use Code Reviewer after code changes or when maintainability and regression risk must be assessed.
- Use QA Security for quality gates, validation evidence and security review.
- Always route final delivery assessment to Tech Lead.
- Use Engineering Knowledge Extractor after Tech Lead approval to extract reusable knowledge and recommend Framework improvements. Its output requires human review before Framework changes.

## Execution Rules

- Follow the selected workflow unless risk, ambiguity or user direction requires a pause.
- Use `protocols/WORKFLOW_UPDATE.md` for workflow and phase updates.
- Use `protocols/AGENT_HANDOFF.md` for agent transitions.
- Use `protocols/TASK_UPDATE.md` for task changes.
- Use `protocols/DECISION_RECORD.md` for decisions.
- Use `protocols/ARTIFACT_UPDATE.md` for artifact changes.
- Update `.ai/state/current-agent.md`, `.ai/state/next-actions.md` and `.ai/state/risks.md` when they change.
- Treat LF-ENGINEERING-SYSTEM as read-only when it is consumed from a client project.

## Stop Conditions

Stop and ask for confirmation before continuing when:

- There is high risk to security, data, production stability or business scope.
- The user prompt has critical ambiguity that affects architecture, data, security or delivery commitment.
- The next step requires a destructive operation.
- The work would require editing LF-ENGINEERING-SYSTEM while operating inside a client project.

## Shared Rules

- Consult `knowledge/INDEX.md` before loading specific knowledge modules.
- Consult `knowledge/REGISTRY.md` before selecting agents or handoff order.
- Consult `.ai/contracts.md` before creating, updating or validating project artifacts.
- Use `.opencode/agents/` adapters as the OpenCode entry points.
- Keep `.ai/` files current when working inside a project.
- Keep `.ai/state/` current when working inside a project.
- Keep final decisions traceable in project documentation.
