# Product Owner Agent Knowledge

Version: 1.2.0

Status: Stable

---

# Purpose

This document defines the Knowledge modules consumed by the Product Owner Agent.

The agent is responsible for transforming business objectives into structured engineering specifications while preserving consistency with the LF Engineering Framework.

It consumes engineering knowledge.

It does not create engineering standards.

---

# Knowledge Philosophy

Good software begins with good requirements.

Every engineering activity depends on a complete, measurable and well-structured product definition.

The Product Owner Agent ensures that engineering starts with clarity rather than assumptions.

---

# Required Modules

## ENGINEERING_FOUNDATIONS

Purpose

Provides the engineering philosophy that guides product definition.

Importance

Critical

---

## ENGINEERING_WORKFLOW

Purpose

Provides understanding of the engineering lifecycle, allowing proper positioning of product activities.

Importance

Critical

---

## ENGINEERING_ARTIFACTS

Purpose

Defines the official engineering artifacts produced and maintained during product definition.

Importance

Critical

---

## ENGINEERING_DECISIONS

Purpose

Supports requirement prioritization and product trade-off analysis.

Importance

Critical

---

## ENGINEERING_STANDARDS

Purpose

Defines documentation quality, consistency and organizational standards.

Importance

High

---

## ENGINEERING_AGENT_GUIDELINES

Purpose

Defines collaboration between the Product Owner Agent and the remaining engineering specialists.

Importance

High

---

# Optional Modules

## ENGINEERING_TEMPLATES

Purpose

Provides standardized templates for PRDs and planning documents.

Importance

Medium

---

## ENGINEERING_QUALITY

Purpose

Supports validation of requirement completeness before implementation.

Importance

Medium

---

## ENGINEERING_DESIGN_PERFORMANCE

Purpose

Supports measurable responsive, performance and accessibility requirements for
web or visual product scope.

Importance

High when applicable.

---

## ENGINEERING_MOTION_DESIGN

Purpose

Defines user-facing motion intent, reduced-motion expectations and measurable
acceptance criteria when motion is explicitly in product scope.

Importance

High when motion is in scope; otherwise not applicable.

---

## ENGINEERING_FIELD_GUIDE

Purpose

Assists in situations involving ambiguous or conflicting business requirements.

Importance

Medium

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Purpose

Supports continuous improvement of product definition processes.

Importance

Low

---

# Project Artifacts

When available, the Product Owner Agent should prioritize:

Mandatory

* PROJECT_BRIEF.md

Recommended

* Prompt refinements
* Existing PRDs
* Business documentation
* Stakeholder notes
* Previous Roadmaps
* Existing Backlog

---

# Knowledge Consumption Priority

Recommended order:

1. Business Context
2. PROJECT_BRIEF.md
3. ENGINEERING_FOUNDATIONS
4. ENGINEERING_WORKFLOW
5. ENGINEERING_ARTIFACTS
6. ENGINEERING_DECISIONS
7. ENGINEERING_DESIGN_PERFORMANCE (when applicable)
8. ENGINEERING_MOTION_DESIGN (when motion is in scope)
9. Supporting Knowledge modules

Business documentation defines the product.

The LF Engineering Framework defines how that product is structured into engineering artifacts.

---

# Knowledge Constraints

The Product Owner Agent should never:

* Invent business requirements.
* Produce technical architecture.
* Override Framework principles.
* Ignore stakeholder objectives.
* Generate implementation details.

Whenever business context is insufficient, assumptions must be explicitly declared.

---

# Future Evolution

Additional Knowledge modules may be incorporated whenever they improve product definition quality without expanding the agent beyond its intended specialization.

---

# Version

Version: 1.2.0

Status: Stable

Derived From:

LF Engineering Knowledge
