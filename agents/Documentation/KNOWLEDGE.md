# Documentation & Technical Writer Agent Knowledge

Version: 1.0.0

Status: Stable

---

# Purpose

This document defines the Knowledge modules consumed by the Documentation & Technical Writer Agent.

The agent is responsible for preserving engineering knowledge consistency across the entire LF Engineering System.

It consumes official Knowledge modules to ensure that every engineering artifact accurately reflects the implemented system.

The agent never creates engineering principles.

It documents and synchronizes them.

---

# Knowledge Philosophy

Documentation is an engineering artifact.

Knowledge must remain:

* Accurate
* Consistent
* Current
* Traceable
* Accessible

The Documentation Agent preserves knowledge.

It does not redefine it.

---

# Required Modules

## ENGINEERING_FOUNDATIONS

Purpose

Provides the engineering philosophy that guides all documentation activities.

Importance

Critical

---

## ENGINEERING_WORKFLOW

Purpose

Provides awareness of the engineering lifecycle, ensuring that documentation remains synchronized throughout every project phase.

Importance

Critical

---

## ENGINEERING_ARTIFACTS

Purpose

Defines the official engineering artifacts maintained by the Documentation Agent.

Importance

Critical

---

## ENGINEERING_STANDARDS

Purpose

Provides documentation standards, naming conventions and organizational principles.

Importance

Critical

---

## ENGINEERING_TEMPLATES

Purpose

Defines the official documentation templates adopted by the LF Engineering System.

Importance

Critical

---

## ENGINEERING_AGENT_GUIDELINES

Purpose

Defines how the Documentation Agent collaborates with the remaining specialized Agents.

Importance

High

---

# Optional Modules

## ENGINEERING_QUALITY

Purpose

Supports documentation quality validation and engineering readiness.

Importance

Medium

---

## ENGINEERING_DECISIONS

Purpose

Provides context for documenting architectural and engineering decisions.

Importance

Medium

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Purpose

Supports documentation evolution and engineering knowledge improvements.

Importance

Medium

---

## ENGINEERING_FIELD_GUIDE

Purpose

Assists documentation activities involving ambiguity or exceptional engineering scenarios.

Importance

Low

---

# Project Artifacts

When available, the Documentation Agent should prioritize:

Mandatory

* PROJECT_BRIEF.md
* PRD.md
* ARCHITECTURE.md
* README.md

Recommended

* CHANGELOG.md
* ADRs
* Sprint documentation
* Review reports
* API documentation
* Database documentation
* Project directory structure

---

# Knowledge Consumption Priority

Recommended order:

1. Project Artifacts
2. ENGINEERING_FOUNDATIONS
3. ENGINEERING_WORKFLOW
4. ENGINEERING_ARTIFACTS
5. ENGINEERING_STANDARDS
6. ENGINEERING_TEMPLATES
7. Supporting Knowledge modules

Project documentation always takes precedence when describing the current implementation.

The LF Engineering Framework remains the authoritative source whenever inconsistencies exist.

---

# Knowledge Constraints

The Documentation Agent should never:

* Invent undocumented functionality.
* Modify approved engineering principles.
* Contradict the LF Engineering Framework.
* Ignore project artifacts.
* Produce documentation unsupported by implementation.

Whenever inconsistencies are identified, they should be reported rather than silently corrected.

---

# Future Evolution

As the LF Engineering System evolves, additional Knowledge modules may be incorporated whenever they improve documentation quality without introducing unnecessary complexity.

---

# Version

Version: 1.0.0

Status: Stable

Derived From:

LF Engineering Knowledge
