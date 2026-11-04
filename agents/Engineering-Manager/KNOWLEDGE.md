# Engineering Manager Agent Knowledge

Version: 1.0.0

Status: Stable

---

# Purpose

This document defines the Knowledge modules consumed by the Engineering Manager Agent.

The agent specializes in operational intake, demand classification and preparation of `MANAGER_BRIEF` for the Orchestrator.

It consumes engineering knowledge.

It does not create engineering standards.

---

# Knowledge Philosophy

Clear classification prevents incorrect execution.

The Engineering Manager Agent should understand the LF Engineering System well enough to route demand into orchestration, while staying outside technical execution.

---

# Required Modules

## ENGINEERING_FOUNDATIONS

Importance

Critical

Purpose

Defines the engineering philosophy and boundary principles used during intake.

---

## ENGINEERING_WORKFLOW

Importance

Critical

Purpose

Defines the lifecycle and supported workflow types used for classification.

---

## ENGINEERING_AGENT_GUIDELINES

Importance

Critical

Purpose

Defines agent boundaries and the separation between intake, orchestration and execution.

---

## ENGINEERING_ARTIFACTS

Importance

High

Purpose

Provides awareness of project artifacts that may affect scope and handoff readiness.

---

## ENGINEERING_QUALITY

Importance

High

Purpose

Supports early identification of quality, security and delivery risks.

---

# Optional Modules

## ENGINEERING_DECISIONS

Purpose

Supports classification when trade-offs or conflicting interpretations exist.

Importance

Medium

---

## ENGINEERING_STANDARDS

Purpose

Supports recognition of requests that may affect framework or project standards.

Importance

Medium

---

## ENGINEERING_FIELD_GUIDE

Purpose

Supports ambiguous intake situations.

Importance

Medium

---

## ENGINEERING_CONTINUOUS_IMPROVEMENT

Purpose

Supports future improvements to intake and classification.

Importance

Low

---

# Project Artifacts

When available, the Engineering Manager Agent should prioritize:

Mandatory

* Raw user prompt

Recommended

* Existing `.ai/` state
* Existing project documentation
* Repository structure
* User-provided constraints
* Current workflow state

---

# Knowledge Consumption Priority

1. Raw user prompt
2. Existing project state
3. ENGINEERING_FOUNDATIONS
4. ENGINEERING_WORKFLOW
5. ENGINEERING_AGENT_GUIDELINES
6. ENGINEERING_ARTIFACTS
7. Supporting Knowledge modules

---

# Knowledge Constraints

The Engineering Manager Agent should never:

* Use knowledge modules to perform specialized technical work.
* Replace the Orchestrator.
* Replace Product Owner, Architect, Reviewer, QA, Documentation or Tech Lead responsibilities.
* Modify framework rules during client project execution.

---

# Version

Version: 1.0.0

Status: Stable
