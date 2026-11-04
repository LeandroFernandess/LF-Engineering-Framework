# Agent Interaction Map

Version: 1.2.0

Status: Stable

---

# Purpose

This document defines how the AI Agents within the LF Engineering System interact with each other across the software development lifecycle.

It provides a systemic view of responsibilities, handoffs, artifact flow and decision points between specialized Agents.

This document does not define individual Agent configuration.

Individual Agent configuration belongs to each Agent directory.

---

# Agent Pipeline

```text
Raw Idea
    │
    ▼
Engineering Manager Agent
    │
    ▼
Orchestrator
    │
    ▼
Prompt Architect Agent (conditional: raw, ambiguous or incomplete context)
    │
    ▼
Product Owner Agent
    │
    ▼
Design System Analyst Agent (when references exist or an initial direction is explicitly requested)
    │
    ▼
Software Architect Agent
    │
    ▼
Sprint Planner Agent
    │
    ▼
Plan approval checkpoint
    │
    ▼
Implementation / selected CLI
    │
    ▼
Code Reviewer Agent
    │
    ▼
Quality Assurance & Security Agent
    │
    ▼
Documentation & Technical Writer Agent
    │
    ▼
Tech Lead Agent
    │
    ▼
Engineering Knowledge Extractor Agent
    │
    ▼
Delivery
```

---

# Engineering Layers

| Layer       | Agents                                                                                                     | Objective                                                               |
| ----------- | ---------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| Intake      | Engineering Manager Agent, Orchestrator                                                                    | Classify demand, select workflow and establish handoff boundaries.       |
| Discovery   | Prompt Architect Agent, Product Owner Agent                                                                | Transform ideas into structured product requirements.                   |
| Engineering | Design System Analyst Agent, Software Architect Agent, Sprint Planner Agent                                | Transform requirements into design documentation, technical architecture and execution plans. |
| Execution   | Implementation / selected CLI                                                                              | Transform approved plans into software.                                 |
| Governance  | Code Reviewer Agent, QA & Security Agent, Documentation Agent, Tech Lead Agent                             | Validate, audit, document and approve engineering progress.             |
| Evolution   | Engineering Knowledge Extractor Agent                                                                      | Extract reusable engineering knowledge from completed projects.          |

---

# Agent Responsibilities

| Agent                               | Main Verb | Core Responsibility                                            |
| ----------------------------------- | --------- | -------------------------------------------------------------- |
| Prompt Architect Agent              | Refine    | Transform raw ideas into structured engineering context.       |
| Product Owner Agent                 | Define    | Transform business needs into PRD and product requirements.    |
| Design System Analyst Agent         | Analyze   | Transform visual references into structured engineering documentation. |
| Software Architect Agent            | Design    | Transform requirements into technical architecture.            |
| Sprint Planner Agent                | Plan      | Transform architecture into executable sprints.                |
| Implementation / selected CLI       | Build     | Implement approved sprint scope.                               |
| Code Reviewer Agent                 | Validate  | Review implementation correctness and maintainability.         |
| QA & Security Agent                 | Verify    | Audit security, performance, quality and production readiness. |
| Documentation Agent                 | Preserve  | Keep documentation synchronized with implementation.           |
| Tech Lead Agent                     | Govern    | Consolidate evidence and approve or block progression.         |
| Engineering Knowledge Extractor Agent | Extract | Extract reusable engineering knowledge from completed projects. |

---

# Artifact Flow

| Artifact                | Produced By                           | Consumed By                                                                                           |
| ----------------------- | ------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| Refined Prompt          | Prompt Architect Agent                | Product Owner Agent, Design System Analyst Agent, Software Architect Agent                           |
| PROJECT_BRIEF.md        | Prompt Architect Agent                | Product Owner Agent, Design System Analyst Agent, Software Architect Agent, Sprint Planner Agent      |
| PRD.md                  | Product Owner Agent                   | Design System Analyst Agent, Software Architect Agent, Sprint Planner Agent, Code Reviewer Agent, QA & Security Agent |
| DESIGN.md               | Design System Analyst Agent           | Software Architect Agent, Sprint Planner Agent, Code Reviewer Agent                                  |
| ARCHITECTURE.md         | Software Architect Agent              | Sprint Planner Agent, Code Reviewer Agent, QA & Security Agent, Documentation Agent                   |
| SPRINTS.md              | Sprint Planner Agent                  | Implementation / selected CLI, Code Reviewer Agent, Tech Lead Agent                                  |
| Source Code             | Implementation / selected CLI         | Code Reviewer Agent, QA & Security Agent, Documentation Agent, Tech Lead Agent                        |
| REVIEW.md               | Code Reviewer Agent                   | QA & Security Agent, Tech Lead Agent                                                                  |
| QA_SECURITY_REPORT.md   | QA & Security Agent                   | Documentation Agent, Tech Lead Agent                                                                  |
| PERFORMANCE_VALIDATION_REPORT.md (conditional) | QA & Security Agent | Documentation Agent, Tech Lead Agent |
| Documentation Audit     | Documentation Agent                   | Tech Lead Agent                                                                                       |
| Governance Report       | Tech Lead Agent                       | Engineering Knowledge Extractor Agent, Future Sprints                                                  |
| PROJECT_KNOWLEDGE.md    | Engineering Knowledge Extractor Agent | Tech Lead Agent, Framework Maintainer, Future Projects                                                |

---

# Handoff Rules

## Prompt Architect → Product Owner

The Prompt Architect Agent must provide enough structured context for the Product Owner Agent to define product requirements.

Expected handoff:

* Refined Prompt
* PROJECT_BRIEF.md
* Assumptions
* Missing information
* Constraints

---

## Product Owner → Software Architect

The Product Owner Agent must provide a PRD that clearly defines what should be built.

Expected handoff:

* PRD.md
* Functional Requirements
* Non-Functional Requirements
* Acceptance Criteria
* Product Scope
* Roadmap
* Critical routes, target profiles and experience requirements when the project has a web or visual interface

---

## Product Owner → Design System Analyst (Conditional)

The Product Owner Agent should provide product context that informs design analysis.

Expected handoff:

* PRD.md
* Product scope
* Functional requirements that affect the UI
* User personas (when available)
* Explicit request and approval expectations for a no-reference direction proposal
* Existing design-system/token sources when available

This handoff occurs when visual references require analysis or the user/Product
Owner explicitly requests a no-reference initial direction for a visual product.
The latter is optional and must remain a proposal until approved.

---

## Design System Analyst → Software Architect

The Design System Analyst Agent must provide structured design documentation that can be consumed by the Software Architect.

Expected handoff:

* DESIGN.md
* Color palette specification
* Typography analysis
* Component hierarchy
* Interaction pattern documentation
* Design tokens
* Accessibility considerations
* Responsive states, asset/font contracts and candidate LCP elements when the project has a web or visual interface
* Frontend implementation considerations

When no visual references exist and no initial direction was explicitly
requested, this handoff is skipped and the Product Owner hands off directly to
the Software Architect.

---

## Software Architect → Sprint Planner

The Software Architect Agent must provide a technical architecture that can be converted into execution steps.

Expected handoff:

* ARCHITECTURE.md
* Component definitions
* Directory structure
* Technical decisions
* Risks
* Trade-offs
* Rendering/delivery strategy, performance budgets and measurement plan when the project has a web or visual interface

---

## Sprint Planner → Implementation / selected CLI

The Sprint Planner Agent must provide executable sprint documentation.

Expected handoff:

* SPRINTS.md
* Scope
* Deliverables
* Expected files
* Acceptance criteria
* Out of scope
* Validation checklist
* Performance baseline and mobile/desktop validation tasks when applicable

---

## Implementation / selected CLI → Code Reviewer

The implementation must be reviewed against the approved sprint scope.

Expected handoff:

* Code changes
* Sprint result summary
* Modified files
* Known limitations
* Implementation observations

---

## Code Reviewer → QA & Security

The Code Reviewer Agent must provide a technical review that supports deeper quality validation.

Expected handoff:

* REVIEW.md
* Findings
* Severity classification
* Technical risks
* Correction recommendations
* Performance-sensitive regression observations when applicable

---

## QA & Security → Documentation

The QA & Security Agent must provide quality findings that may impact documentation.

Expected handoff:

* QA Report
* Security findings
* Performance findings
* `PERFORMANCE_VALIDATION_REPORT.md` when applicable
* Production readiness assessment
* Required documentation updates

---

## Documentation → Tech Lead

The Documentation Agent must confirm whether project documentation is synchronized with the current implementation.

Expected handoff:

* Documentation Audit
* Updated documentation recommendations
* Missing documentation
* CHANGELOG suggestions
* ADR recommendations

---

## Tech Lead → Engineering Knowledge Extractor

The Tech Lead Agent must provide the complete project context for knowledge extraction.

Expected handoff:

* Governance Report
* All project artifacts (PRD, DESIGN, ARCHITECTURE, SPRINTS)
* Source code
* REVIEW.md
* QA Report
* `PERFORMANCE_VALIDATION_REPORT.md` when applicable
* Documentation Audit
* CHANGELOG
* ADRs

---

## Engineering Knowledge Extractor → Framework Evolution

The Engineering Knowledge Extractor Agent produces actionable knowledge for Framework improvement.

Expected handoff:

* PROJECT_KNOWLEDGE.md
* Technical stack summary
* New engineering knowledge identified
* Suggested Framework improvements
* Prioritized recommendations

All recommendations require human review before Framework changes are applied.

---

## Tech Lead → Delivery or Correction

The Tech Lead Agent consolidates all evidence and decides whether the project can progress.

Possible outcomes:

* Approved
* Blocked

No intermediate final status should be used.

---

# Decision Points

| Decision Point                  | Responsible Agent                   | Possible Outcome                  |
| ------------------------------- | ----------------------------------- | --------------------------------- |
| Context ready for PRD           | Prompt Architect Agent              | Continue / Request clarification  |
| PRD ready for architecture      | Product Owner Agent                 | Continue / Refine requirements    |
| References exist or an initial direction is explicitly requested | Design System Analyst Agent | Continue / Skip (neither condition applies) |
| Design ready for architecture   | Design System Analyst Agent         | Continue / Request clarification or approval |
| Architecture ready for planning | Software Architect Agent            | Continue / Resolve technical gaps |
| Sprint ready for implementation | Sprint Planner Agent                | Continue / Adjust sprint scope    |
| Implementation ready for QA     | Code Reviewer Agent                 | Approved / Requires correction    |
| Sprint ready for governance     | QA & Security Agent                 | Approved / Requires adjustment    |
| Documentation synchronized      | Documentation Agent                 | Updated / Requires update         |
| Project can progress            | Tech Lead Agent                     | Approved / Blocked                |
| Knowledge extraction complete   | Engineering Knowledge Extractor Agent | Ready for review / Insufficient artifacts |

---

# Governance Model

The Tech Lead Agent is the final technical authority within the Agent workflow.

However, the Tech Lead Agent does not replace specialized Agents.

It consolidates evidence produced by:

* Product Owner Agent
* Software Architect Agent
* Sprint Planner Agent
* Code Reviewer Agent
* QA & Security Agent
* Documentation Agent

A sprint should only progress when the Tech Lead Agent issues an explicit approval.

---

# Conflict Resolution

When Agent outputs conflict:

1. Preserve the LF Engineering Framework.
2. Prioritize approved project artifacts.
3. Follow engineering decision priorities.
4. Escalate to the Tech Lead Agent.
5. Document the final decision when relevant.

---

# Knowledge Relationship

Agents do not own engineering knowledge.

Agents consume Knowledge modules from the `knowledge/` directory.

Each Agent declares its required Knowledge modules inside its own `KNOWLEDGE.md`.

The `AGENT_INTERACTION_MAP.md` describes interaction.

It does not duplicate Knowledge rules.

---

# Expansion Guidelines

New Agents may be added when a new specialization becomes necessary.

Before creating a new Agent, verify:

* The responsibility is not already covered.
* The Agent has a clear primary verb.
* The Agent produces or validates a specific artifact.
* The Agent can be integrated into the existing workflow.
* The Agent consumes existing Knowledge modules.
* The Agent may be conditional (runs only when specific inputs exist).

The Design System Analyst Agent and Engineering Knowledge Extractor Agent serve as examples of proper expansion: each has a unique primary verb (Analyze, Extract), each produces a single primary artifact (DESIGN.md, PROJECT_KNOWLEDGE.md), and each integrates cleanly into the existing pipeline without overlapping responsibilities.

---

# Final Statement

The LF Engineering Agents operate as a coordinated engineering system.

Each Agent has one primary responsibility, one clear position in the workflow and one specific contribution to software quality.

The value of the system comes from the interaction between specialized roles, not from any single Agent operating alone.

The system is designed to evolve. New Agents may be added when new specializations become necessary, as long as they preserve the architectural principles that define the ecosystem.
