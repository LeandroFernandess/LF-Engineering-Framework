# Sprint Planner Agent Knowledge

Version: 1.2.0

Status: Stable

---

# Purpose

This document defines the Knowledge modules consumed by the Sprint Planner Agent.

The agent specializes in execution planning, backlog organization and Sprint decomposition.

Its responsibility is to transform architecture into an executable engineering roadmap.

---

# Knowledge Philosophy

Good execution begins with good planning.

Implementation should follow a logical sequence of small, independent and verifiable deliverables.

The Sprint Planner Agent organizes engineering execution.

It does not redesign engineering decisions.

---

# Required Modules

## ENGINEERING_FOUNDATIONS

Importance

Critical

Purpose

Defines the engineering philosophy guiding execution planning.

---

## ENGINEERING_WORKFLOW

Importance

Critical

Purpose

Defines how Sprint Planning integrates with the software engineering lifecycle.

---

## ENGINEERING_ARTIFACTS

Importance

Critical

Purpose

Defines Sprint documentation and implementation artifacts.

---

## ENGINEERING_DECISIONS

Importance

High

Purpose

Supports planning decisions involving implementation sequencing and dependency analysis.

---

## ENGINEERING_STANDARDS

Importance

High

Purpose

Defines planning consistency, documentation standards and engineering organization.

---

## ENGINEERING_AGENT_GUIDELINES

Importance

High

Purpose

Defines collaboration with Software Architect, Product Owner and Code Reviewer Agents.

---

## ENGINEERING_DESIGN_PERFORMANCE

Purpose

Provides route/profile coverage, budget, baseline and acceptance guidance for
performance tasks in web and visual projects.

Importance

High when applicable.

---

## ENGINEERING_MOTION_DESIGN

Purpose

Provides conditional task and acceptance-evidence guidance for motion behavior,
reduced-motion alternatives and representative visual validation.

Importance

High when motion is in scope; otherwise not applicable.

---

# Optional Modules

## ENGINEERING_QUALITY

Purpose

Supports planning quality validation before implementation.

Importance

Medium

---

## ENGINEERING_TEMPLATES

Purpose

Provides standardized Sprint documentation templates.

Importance

Medium

---

## ENGINEERING_FIELD_GUIDE

Purpose

Supports planning decisions under uncertainty.

Importance

Medium

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Purpose

Improves Sprint planning methodology over time.

Importance

Low

---

# Project Artifacts

Mandatory

* PROJECT_BRIEF.md
* PRD.md
* ARCHITECTURE.md

Recommended

* Existing Backlog
* Previous Sprint Reports
* Technical Constraints
* Engineering Priorities

---

# Knowledge Consumption Priority

1. PROJECT_BRIEF.md

2. PRD.md

3. ARCHITECTURE.md

4. ENGINEERING_FOUNDATIONS

5. ENGINEERING_WORKFLOW

6. ENGINEERING_ARTIFACTS

7. ENGINEERING_DESIGN_PERFORMANCE (when applicable)

8. ENGINEERING_MOTION_DESIGN (when motion is in scope)

9. Supporting Knowledge modules

---

# Knowledge Constraints

The Sprint Planner Agent should never:

* Modify business requirements.
* Redesign architecture.
* Invent implementation details.
* Ignore engineering dependencies.

Whenever planning assumptions exist, they must always be explicitly documented.

---

# Future Evolution

The Sprint Planner Agent should evolve alongside agile engineering practices while preserving consistency with the LF Engineering Framework.

---

# Version

Version: 1.2.0

Status: Stable

Derived From:

LF Engineering Knowledge
