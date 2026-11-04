# Engineering Workflow

Version: 0.3.0
Status: Draft
Owner: Leandro Fernandes

---

# Purpose

This module defines the official engineering workflow adopted by the LF Engineering System.

Its purpose is to standardize how projects evolve from an initial idea to a completed and documented software product.

This module defines process only.

Implementation details belong to other knowledge modules.

---

# Scope

This module defines:

* Engineering lifecycle
* Development phases
* Phase transitions
* Inputs and outputs
* Delivery flow

---

# Consumers

Primary Consumers:

* Prompt Architect Agent
* Product Owner Agent
* Sprint Planner Agent
* Documentation Agent
* Tech Lead Agent

Secondary Consumers:

* Software Architect Agent
* Code Reviewer Agent
* QA & Security Agent

---

# Dependencies

Required:

* ENGINEERING_FOUNDATIONS

Related:

* ENGINEERING_ARTIFACTS
* ENGINEERING_TEMPLATES
* ENGINEERING_QUALITY

---

# Source

Derived from:

LF Engineering Framework

Sections:

* Workflow
* Sprint Process
* Engineering Lifecycle

---

# Responsibilities

This module defines:

* The official development lifecycle.
* How engineering artifacts evolve.
* When a project advances to the next phase.

---

# Engineering Lifecycle

Every project follows the same lifecycle:

1. Discovery
2. Refinement
3. Planning
4. Architecture
5. Sprint Planning
6. Implementation
7. Code Review
8. Quality Assurance
9. Documentation
10. Technical Approval
11. Delivery
12. Continuous Improvement

Projects should not skip lifecycle stages without explicit technical justification.

---

# Phase Description

## Discovery

Objective:

Understand the problem.

Output:

Raw Project Context.

Responsible:

Engineering Manager / Prompt Architect Agent when needed

---

## Refinement

Objective:

Transform ideas into structured requirements.

Output:

Refined Prompt

Project Vision

Responsible:

Prompt Architect Agent

---

## Planning

Objective:

Create the official PRD.

Output:

PRD.md

Responsible:

Product Owner Agent

---

## Architecture

Objective:

Define the technical solution.

Output:

ARCHITECTURE.md

Responsible:

Software Architect Agent

---

## Sprint Planning

Objective:

Break the project into executable increments.

Output:

Sprint Backlog

Responsible:

Sprint Planner Agent

---

## Implementation

Objective:

Develop the approved Sprint.

Output:

Working Software

Responsible:

Implementation / selected CLI

---

## Code Review

Objective:

Validate implementation quality.

Output:

Review Report

Responsible:

Code Reviewer Agent

---

## Quality Assurance

Objective:

Validate functional and technical quality.

Output:

Quality Report

Responsible:

QA & Security Agent

---

## Documentation

Objective:

Update engineering artifacts.

Output:

README

CHANGELOG

Documentation

Responsible:

Documentation Agent

---

## Technical Approval

Objective:

Validate readiness for release.

Output:

Approval Decision

Responsible:

Tech Lead Agent

Developer

---

## Delivery

Objective:

Publish the approved version.

Output:

Release

Version Tag

---

## Continuous Improvement

Objective:

Capture lessons learned.

Output:

Framework Improvements

Knowledge Improvements

Responsible:

Developer

Tech Lead Agent

---

# Workflow Rules

## Intake and Design Readiness

Before selecting an implementation approach, the responsible agent must state the problem, desired outcome, constraints, assumptions, open questions and evidence available. If the result is not sufficiently understood, pause and request clarification rather than generating implementation.

Before implementation, the plan must identify affected files, acceptance criteria, tests, dependencies, risks and explicit exclusions. The user or designated technical approver must approve the plan.

## Validation Loop

Implementation follows a test-first loop whenever the project supports automated tests: define the expected behavior, observe the failing test or validation, implement the smallest change, then run the relevant checks. Review and QA validate the consumer-visible behavior and the actual evidence, not only the intended API or documentation.

## Handoff Completeness

Every handoff records the current phase, owner, artifact status, decisions, risks, next action and the exact evidence needed to continue. A handoff must not imply completion when code, tests or validation evidence are missing.

## Conditional Web and Interface Performance Track

When a project has a web or visual interface, performance is designed and
validated throughout the lifecycle rather than deferred to the final audit:

1. **Discovery and Product Definition:** identify critical routes, audience,
   mobile/desktop profiles, representative journeys and experience targets.
2. **Design:** document responsive composition, loading states, asset/font
   contracts, candidate LCP elements, accessibility and reduced-motion states.
3. **Architecture:** define rendering, bundle, network, server, cache,
   third-party and observability strategies plus route-specific budgets.
4. **Sprint Planning:** create measurable performance tasks and an early
   production-build baseline; include both mobile and desktop.
5. **Implementation:** preserve the approved budgets and measure representative
   routes before late-stage polish.
6. **Code Review and QA:** review regressions and execute
   `protocols/PERFORMANCE_VALIDATION.md`, producing the conditional
   `PERFORMANCE_VALIDATION_REPORT.md`.
7. **Technical Approval:** Tech Lead accepts, blocks or records a traceable
   exception using separate mobile and desktop evidence.
8. **Post-publication:** monitor RUM/CrUX when available and record sampling
   limitations; missing field data is not approval.

Non-visual projects record the conditional skip and its scope in the project
decision and QA report. They must not invent browser performance evidence.

Rule 01

Every project starts with Discovery.

Priority:
Critical

---

Rule 02

Every implementation requires an approved PRD and Architecture.

Priority:
Critical

---

Rule 03

No Sprint should begin without planning.

Priority:
Critical

---

Rule 04

Every implementation must pass Code Review.

Priority:
Critical

---

Rule 05

Every project must complete QA before delivery.

Priority:
Critical

---

Rule 06

Documentation must be updated before technical approval.

Priority:
High

---

Rule 07

Every completed project should contribute to Continuous Improvement.

Priority:
Medium

---

# Best Practices

* Complete one phase before starting the next.
* Keep engineering artifacts synchronized.
* Document significant decisions.
* Validate outputs at every transition.
* Preserve workflow consistency.

---

# Anti-Patterns

Avoid:

* Skipping planning.
* Implementing without architecture.
* Delivering without QA.
* Updating documentation after release.
* Ignoring retrospective learnings.

---

# Workflow Decision Matrix

| Situation            | Action                           |
| -------------------- | -------------------------------- |
| New Project          | Start at Discovery               |
| Existing Project     | Validate current lifecycle stage |
| Major Scope Change   | Return to Planning               |
| Architectural Change | Revisit Architecture             |
| Failed Review        | Return to Implementation         |
| Failed QA            | Correct before Delivery          |
| Project Completion   | Execute Continuous Improvement   |

---

# Related Modules

ENGINEERING_FOUNDATIONS

ENGINEERING_ARTIFACTS

ENGINEERING_QUALITY

ENGINEERING_TEMPLATES

ENGINEERING_CONTINUOUS_IMPROVEMENT

---

# Versioning

Version: 0.3.0

Status: Draft

Derived From:

LF Engineering Framework

Last Updated:

2026
