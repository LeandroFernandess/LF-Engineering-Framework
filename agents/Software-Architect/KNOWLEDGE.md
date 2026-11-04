# Software Architect Agent Knowledge

Version: 1.2.0

Status: Stable

---

# Purpose

This document defines the Knowledge modules consumed by the Software Architect Agent.

The agent specializes in technical architecture and engineering decision-making.

Its responsibility is to transform approved product requirements into robust software architectures.

---

# Knowledge Philosophy

Architecture is a sequence of intentional engineering decisions.

Every decision should balance business objectives, technical constraints and long-term maintainability.

The Software Architect Agent designs engineering solutions.

It does not implement them.

---

# Required Modules

## ENGINEERING_FOUNDATIONS

Importance

Critical

Purpose

Defines the engineering philosophy.

---

## ENGINEERING_DECISIONS

Importance

Critical

Purpose

Provides architectural decision methodology and trade-off analysis.

---

## ENGINEERING_STANDARDS

Importance

Critical

Purpose

Defines engineering standards and architectural consistency.

---

## ENGINEERING_WORKFLOW

Importance

High

Purpose

Defines how architecture integrates with the engineering lifecycle.

---

## ENGINEERING_ARTIFACTS

Importance

High

Purpose

Defines ARCHITECTURE.md and related engineering artifacts.

---

## ENGINEERING_AGENT_GUIDELINES

Importance

High

Purpose

Defines collaboration with Product Owner, Sprint Planner and QA Agents.

---

## ENGINEERING_DESIGN_PERFORMANCE

Purpose

Defines responsive design handoffs, web performance budgets, route/profile
coverage and validation expectations for architectural decisions.

Importance

High when the project has a web or visual interface; otherwise conditional.

---

## ENGINEERING_MOTION_DESIGN

Purpose

Defines architecture handoffs for the selected motion system, reduced-motion
integration, lifecycle cleanup and motion-related performance risks.

Importance

High when motion is in scope; otherwise not applicable.

---

# Optional Modules

## ENGINEERING_QUALITY

Purpose

Supports architecture quality validation.

Importance

Medium

---

## ENGINEERING_TEMPLATES

Purpose

Provides standardized architecture templates.

Importance

Medium

---

## ENGINEERING_FIELD_GUIDE

Purpose

Supports architectural judgment in ambiguous scenarios.

Importance

Medium

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Purpose

Supports architecture evolution over time.

Importance

Low

---

# Project Artifacts

Mandatory

- PROJECT_BRIEF.md
- PRD.md

Recommended

- Existing Architecture
- Technology Constraints
- Integration Documentation
- Design References

---

# Knowledge Consumption Priority

1. PROJECT_BRIEF.md

2. PRD.md

3. ENGINEERING_FOUNDATIONS

4. ENGINEERING_DECISIONS

5. ENGINEERING_STANDARDS

6. ENGINEERING_WORKFLOW

7. ENGINEERING_DESIGN_PERFORMANCE (when applicable)

8. ENGINEERING_MOTION_DESIGN (when motion is in scope)

9. Supporting Knowledge modules

---

# Knowledge Constraints

The Software Architect Agent should never:

- Invent business requirements.
- Produce implementation code.
- Ignore architectural trade-offs.
- Contradict the LF Engineering Framework.

Whenever uncertainty exists, architectural assumptions must be explicitly documented.

---

# Future Evolution

The Software Architect Agent should evolve alongside modern software architecture practices while preserving consistency with the LF Engineering Framework.

---

# Version

Version: 1.2.0

Status: Stable

Derived From:

LF Engineering Knowledge
