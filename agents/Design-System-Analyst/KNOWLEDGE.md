# Design System Analyst Agent Knowledge

Version: 1.3.0

Status: Stable

---

# Purpose

This document defines the Knowledge modules consumed by the Design System Analyst Agent.

The agent is responsible for transforming visual references into structured engineering documentation. When explicitly requested, it may also propose an initial visual direction for a visual product without references, clearly separated from reference-based observations.

It consumes engineering knowledge.

It does not create engineering standards.

---

# Knowledge Philosophy

Visual design becomes implementable when documented in engineering terms.

Every design element should be translated into structured specifications that the Software Architect can consume directly.

The Design System Analyst Agent ensures that reference observations and optional proposals become traceable engineering artifacts rather than subjective or unsupported claims.

---

# Required Modules

## ENGINEERING_FOUNDATIONS

Purpose

Provides the engineering philosophy that guides systematic design analysis.

Importance

Critical

---

## ENGINEERING_WORKFLOW

Purpose

Provides understanding of the engineering lifecycle, allowing proper positioning of design analysis activities.

Importance

Critical

---

## ENGINEERING_ARTIFACTS

Purpose

Defines the official engineering artifacts produced and consumed during design analysis.

Importance

Critical

---

## ENGINEERING_STANDARDS

Purpose

Defines documentation quality, consistency and organizational standards for design artifacts.

Importance

High

---

## ENGINEERING_DESIGN_PERFORMANCE

Purpose

Defines responsive design contracts, asset/font guidance, performance budgets
and mobile/desktop validation handoffs for web and visual projects.

Importance

High when the project has a web or visual interface; otherwise not applicable.

---

## ENGINEERING_MOTION_DESIGN

Purpose

Defines the conditional motion contract for intent, hierarchy, interaction,
reduced-motion alternatives and visual review evidence.

Importance

High when motion is in scope; otherwise not applicable.

---

## ENGINEERING_AGENT_GUIDELINES

Purpose

Defines collaboration between the Design System Analyst Agent and the remaining engineering specialists.

Importance

High

---

# Optional Modules

## ENGINEERING_TEMPLATES

Purpose

Provides standardized templates for design documentation.

Importance

Medium

---

## ENGINEERING_FIELD_GUIDE

Purpose

Assists in situations involving unusual or complex visual patterns.

Importance

Medium

---

## ENGINEERING_AI_COLLABORATION

Purpose

Supports effective collaboration with other AI Agents during design handoff.

Importance

Low

---

# Project Artifacts

When this agent is invoked, it should prioritize:

Required for reference analysis:

* Visual references (screenshots, mockups, interface images)

For a no-reference proposal, an explicit user or Product Owner request and enough
approved product context to ground the proposal are required. If context is
insufficient, ask for clarification instead of filling gaps with assumptions.

Recommended

* PRD.md
* PROJECT_BRIEF.md
* Brand guidelines
* Existing design system documentation

---

# Knowledge Consumption Priority

Recommended order:

1. Visual references (primary input for reference analysis; not required for an explicitly requested proposal)
2. `PRD.md`, `PROJECT_BRIEF.md` and approved design-system/token sources
3. `ENGINEERING_FOUNDATIONS`
4. `ENGINEERING_WORKFLOW`
5. `ENGINEERING_ARTIFACTS`
6. `ENGINEERING_STANDARDS`
7. `ENGINEERING_DESIGN_PERFORMANCE` (when applicable)
8. `ENGINEERING_MOTION_DESIGN` (when motion is in scope)
9. Supporting Knowledge modules

Visual references define what is observed. A no-reference direction is a
recommendation, not an observation or evidence of user preference.

The LF Engineering Framework defines how that is documented for engineering consumption.

---

# Knowledge Constraints

The Design System Analyst Agent should never:

* Present invented design elements as observed in supplied references.
* Present `Derived`, `Proposed` or `Unverified` content as `Observed`.
* Treat heuristics or catalog matches as user research, preference or validation.
* Replace approved design tokens with a competing system; page-specific
  overrides require a stated scope, rationale and approval.
* Produce technical architecture.
* Override Framework principles.
* Generate implementation code.
* Replace the Software Architect.

When references or approved product context are insufficient, declare the
limitations and request clarification. Any initial direction without references
must be labeled `Proposed` and approved before becoming the implementation
baseline.

---

# Future Evolution

Additional Knowledge modules may be incorporated whenever they improve design analysis quality without expanding the agent beyond its intended specialization.

---

# Version

Version: 1.3.0

Status: Stable

Derived From:

LF Engineering Knowledge
